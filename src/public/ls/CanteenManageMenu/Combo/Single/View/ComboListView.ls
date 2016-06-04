eventbus 						= require "../eventbus.js"

class ComboListView

	(options)->
		@assign options
		@init!

	assign: (options)!->
		@combo-controller 		= 	options.combo-controller
		@category-controller 	= 	options.category-controller
		@$el 									= 	$ options.el-CSS-selector

	init: !->
		@init-all-prepare!
		@render-all-dom!
		@init-all-event!
		@set-default-state!

	init-all-prepare: !->
		@all-combo-list-doms 	= {}
		@all-combo-doms 			= {}

	render-all-dom: !->
		all-combos = @combo-controller.get-all-combos!
		for category-id, combo-array of all-combos
			combo-list-dom 											= @create-combo-list-dom!
			@$el.append combo-list-dom
			@all-combo-list-doms[category-id] 	= combo-list-dom
			@all-combo-doms[category-id] 				= []
			for combo in combo-array
				combo-dom 												= @create-combo-dom combo-list-dom
				combo-list-dom.append combo-dom
				@all-combo-doms[category-id].push combo-dom


	init-all-event: !->
		eventbus.on "controller:category:toggle-current-category-id", (category-id)!~> @only-show-combo-list-dom-by-given-id category-id

	set-default-state: !->
		current-category-id = @category-controller.get-current-category-id!
		@only-show-combo-list-dom-by-given-id current-category-id

	hide-all-combo-list-doms-except-given-id: (category-id_)!->
		for category-id, combo-list-dom of @all-combo-list-doms
			if category-id isnt category-id_ then combo-list-dom.fade-out 100

	show-combo-list-dom-by-given-id: (category-id)!->
		@all-combo-list-doms[category-id].fade-in 100

	only-show-combo-list-dom-by-given-id: (category-id)!->
		@hide-all-combo-list-doms-except-given-id category-id
		set-timeout (!~> @show-combo-list-dom-by-given-id category-id), 100

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
																<div class='name-field total-center'>
																	<p></p>
																</div>
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
														</div>"
		return combo-dom.html combo-dom-inner-html

module.exports = ComboListView

