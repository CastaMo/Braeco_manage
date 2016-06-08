eventbus 						= require "../eventbus.js"

class ComboListView

	(options)->
		@assign options
		@init!

	assign: (options)!->
		@combo-controller 		= 	options.combo-controller
		@category-controller 	= 	options.category-controller
		@subitem-controller 	= 	options.subitem-controller
		@$el 									= 	$ options.el-CSS-selector
		@all-default-states 	= 	options.all-default-states

	init: !->
		@init-all-prepare!
		@render-all-dom!
		@init-all-event!
		@set-default-state!

	init-all-prepare: !->
		@all-combo-list-doms 	= {}
		@all-combo-doms 			= {}
		@all-choose-dom 			= @$el.parent "\#combo-table"
																.find 	".combo-head .choose-icon"

	render-all-dom: !->
		datas = @combo-controller.get-datas!
		for data in datas
			combo-list-dom 									= @create-combo-list-dom!
			@$el.append combo-list-dom
			@all-combo-list-doms[data.id] 	= combo-list-dom
			@all-combo-doms[data.id] 				= {}
			for dish in data.dishes when dish.type isnt "normal"
				combo-dom-object 									= {}
				$el = combo-dom-object.$el 				= @create-combo-dom combo-list-dom
				combo-dom-object.choose-dom 			= $el.find ".t-choose .choose-icon"
				combo-dom-object.pic-dom 					= $el.find ".t-pic .pic"
				combo-dom-object.name-dom 				= $el.find ".t-name .name-field"
				combo-dom-object.price-dom 				= $el.find ".t-price p"
				combo-dom-object.subitem-dom 			= $el.find ".t-subitem .subitem-field"
				combo-dom-object.dc-dom 					= $el.find ".t-dc .dc-field"
				combo-dom-object.remark-dom 			= $el.find ".t-remark p"
				combo-dom-object.cover-dom 				= $el.find ".hide-cover"

				combo-list-dom.append $el
				@all-combo-doms[data.id][dish.id] = combo-dom-object
				@update-combo-dom-detail-from-data data.id, dish.id


	init-all-event: !->
		@all-choose-dom	.parent ".t-choose"
										.click !~>
											is-all-choose 			= @combo-controller.get-is-all-choose!
											current-category-id = @category-controller.get-current-category-id!
											@combo-controller.set-is-all-choose current-category-id, !is-all-choose

		eventbus.on "controller:category:current-category-id-change", (category-id, old-category-id)!~> @only-show-combo-list-dom-by-given-id category-id

		eventbus.on "controller:combo:current-combo-ids-change", (current-combo-ids)!~> @show-choose-for-combo-doms-by-current-combo-ids current-combo-ids

		eventbus.on "controller:combo:is-all-choose-change", (is-all-choose)!~> @show-is-all-choose is-all-choose

		eventbus.on "controller:combo:set-able", (category-id, combo-id)!~> @update-combo-dom-detail-from-data category-id, combo-id

		eventbus.on "controller:combo:remove", (category-id, combo-id)!~> @remove-combo-dom category-id, combo-id

		for let category-id, combos of @all-combo-doms
			for let combo-id, combo-dom-object of combos
				combo-dom-object.$el
												.find ".t-choose"
												.click !~>
													current-is-choose = @combo-controller.get-combo-is-choose category-id, combo-id
													@combo-controller.set-is-choose category-id, combo-id, !current-is-choose


	set-default-state: !->
		current-category-id = @all-default-states.shift!.default-category-id
		@only-show-combo-list-dom-by-given-id current-category-id

	update-combo-dom-detail-from-data: (category-id, combo-id)!->
		combo 						= @combo-controller.get-combo category-id, combo-id
		combo-dom-object 	= @all-combo-doms[category-id][combo-id]
		combo-dom-object.pic-dom
										.css {"background-image":""}
		if combo.get-pic!
			combo-dom-object.pic-dom.css {"background-image":"url(#{combo.get-pic!})"}
		combo-dom-object.name-dom
										.html "<p>#{combo.get-c-name!}</p><p>#{combo.get-e-name!}</p>"

		if combo.get-type! is "combo_sum"
			combo-dom-object.price-dom.html "#{combo.get-default-price!}元"
		else combo-dom-object.price-dom.html "子项加总"

		combo-dom-object.subitem-dom.html ""
		for subitem-id in combo.get-groups!
			dom = $ "<p>#{@subitem-controller.get-subitem-name subitem-id}</p>"
			combo-dom-object.subitem-dom.append dom

		combo-dom-object.remark-dom
										.html combo.get-detail!

		if combo.able then combo-dom-object	.cover-dom .fade-out 200
		else combo-dom-object .cover-dom .fade-in 200

	hide-all-combo-list-doms-except-given-id: (category-id_)!->
		for category-id, combo-list-dom of @all-combo-list-doms
			if category-id isnt category-id_ then combo-list-dom.fade-out 100

	show-combo-list-dom-by-given-id: (category-id)!->
		@all-combo-list-doms[category-id].fade-in 100

	only-show-combo-list-dom-by-given-id: (category-id)!->
		@hide-all-combo-list-doms-except-given-id category-id
		set-timeout (!~> @show-combo-list-dom-by-given-id category-id), 100

	show-choose-for-combo-doms-by-current-combo-ids: (current-combo-ids)!->
		current-category-id = @category-controller.get-current-category-id!
		for combo-id, combo-dom-object of @all-combo-doms[current-category-id]
			combo-dom-object.choose-dom
											.remove-class "choose"
		for combo-id in current-combo-ids
			combo-dom-object = @all-combo-doms[current-category-id][combo-id]
			combo-dom-object.choose-dom
											.add-class "choose"

	show-is-all-choose: (is-all-choose)!->
		if is-all-choose then @all-choose-dom.add-class "choose"
		else @all-choose-dom.remove-class "choose"

	remove-combo-dom: (category-id, combo-id)!->
		combo-dom-object = @all-combo-doms[category-id][combo-id]
		combo-dom-object.$el.fade-out 200, !~>
			combo-dom-object.$el.remove!
			delete @all-combo-doms[category-id][combo-id]

	create-combo-list-dom: !->
		combo-list-dom = $ "<ul class='combo-list'></ul>"
		return combo-list-dom

	create-combo-dom: !->
		combo-dom = $ "<li class='combo'></li>"
		combo-dom-inner-html = "<div class='combo-info parallel-container'>
															<div class='t-choose'>
																<div class='choose-field total-center'>
																	<div class='choose-icon'></div>
																</div>
															</div>
															<div class='t-pic left-right-border'>
																<div class='pic-field total-center'>
																	<div class='pic default-square-image'></div>
																</div>
															</div>
															<div class='t-name'>
																<div class='name-field total-center'></div>
															</div>
															<div class='t-price left-right-border'>
																<div class='price-field total-center'>
																	<p></p>
																</div>
															</div>
															<div class='t-subitem'>
																<div class='subitem-field total-center'></div>
															</div>
															<div class='t-dc left-right-border'>
																<div class='dc-field'></div>
															</div>
															<div class='t-remark'>
																<div class='remark-field total-center'>
																	<p></p>
																</div>
															</div>
															<div class='clear'></div>
														</div>
														<div class='combo-cover'>
															<div class='hide-cover'>
																<p>售罄中</p>
															</div>
														</div>"
		return combo-dom.html combo-dom-inner-html

module.exports = ComboListView

