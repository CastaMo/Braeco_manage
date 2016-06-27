eventbus = require "../eventbus.js"
VBase = require "../Utils/VBase.js"

class SubitemModifyView extends VBase
	(options)-> super options

	assign: (options)!->
		@subitem-modify-controller 	= options.subitem-modify-controller
		@page-controller 						= options.page-controller
		@subitem-modify-model 			= options.subitem-modify-model
		@$el 												= $ options.el-CSS-selector

	init-all-prepare: !->
		@datas 											= @subitem-modify-model.get-datas!
		@dish-elem-dom 							= @$el.find ".dish-elem-container"
		@all-choose-dom 						= @$el.find ".all-choose"
		@all-dish-list-doms 				= {}
		@all-category-doms 					= {}
		@all-dish-doms 							= {}
		@title-dom 									= @$el.find ".head-field p"
		@name-dom 									= @$el.find ".name-field input"
		@remark-dom 								= @$el.find ".remark-field input"
		@combo-type-select-dom 			= @$el.find ".price-field select"
		@number-dom 								= @$el.find ".price-field input"

	init-all-dom: !->
		for data in @datas when data.dishes.length > 0
			category-elem-dom = @create-category-elem-dom!
			@dish-elem-dom.append category-elem-dom

			category-dom = @create-category-dom data.name
			category-elem-dom.append category-dom
			@all-category-doms[data.id] = category-dom

			dish-list-dom = @create-dish-list-dom!
			category-elem-dom.append dish-list-dom
			@all-dish-list-doms[data.id] = dish-list-dom

			@all-dish-doms[data.id] = {}

			for dish in data.dishes when dish.type is "normal"
				dish-dom = @create-dish-dom dish.name
				dish-list-dom.append dish-dom
				@all-dish-doms[data.id][dish.id] = dish-dom

	init-all-event: !->

		@$el.find(".cancel-btn").click !~> @cancel-btn-click-event!

		@$el.find(".confirm-btn").click !~> @confirm-btn-click-event!

		@all-choose-dom.click !~> @all-choose-btn-click-event!

		for let category-id, category-dom of @all-category-doms
			category-dom.click !~>
				@subitem-modify-controller.toggle-is-category-active category-id

			category-dom.find(".right-part").click (e)!~>
				@subitem-modify-controller.toggle-is-category-choose category-id
				return false

		for let category-id, dish-doms of @all-dish-doms
			for let dish-id, dish-dom of dish-doms
				dish-dom.click !~>
					@subitem-modify-controller.toggle-is-dish-choose category-id, dish-id

		eventbus.on "model:subitem-modify:is-all-choose-change", (is-choose)!~>
			@change-choose-for-all-choose is-choose

		eventbus.on "model:subitem-modify:is-category-active-change", (category-id, is-active)!~>
			@change-active-for-category-by-id category-id, is-active

		eventbus.on "model:subitem-modify:is-category-choose-change", (category-id, is-choose)!~>
			@change-choose-for-category-by-id category-id, is-choose

		eventbus.on "model:subitem-modify:is-dish-choose-change", (category-id, dish-id, is-choose)!~>
			@change-choose-for-dish category-id, dish-id, is-choose

		eventbus.on "model:subitem-modify:state-change", (state)!~>
			@change-title-by-state state

		eventbus.on "model:subitem-modify:read-from-subitem", (subitem)!~>
			@read-from-subitem subitem

		eventbus.on "model:subitem-modify:reset", !~>
			@reset!

	cancel-btn-click-event: !->
		@page-controller.toggle-change "main"

	confirm-btn-click-event: !->
		@subitem-modify-controller.submit-data-and-try-require {
			name  		: 		@name-dom.val!
			remark 		: 		@remark-dom.val!
			type 			: 		@combo-type-select-dom.val!
			num 			: 		@number-dom.val!
		}, !~> @page-controller.toggle-change "main"

	all-choose-btn-click-event: !->
		@subitem-modify-controller.toggle-is-all-choose!

	change-choose-for-all-choose: (is-choose)!->
		if is-choose
			@all-choose-dom.add-class "choose"
		else
			@all-choose-dom.remove-class "choose"

	change-active-for-category-by-id: (category-id, is-active)!->
		if is-active
			@all-category-doms[category-id].add-class "active"
			@all-dish-list-doms[category-id].slide-down!
		else
			@all-category-doms[category-id].remove-class "active"
			@all-dish-list-doms[category-id].slide-up!

	change-choose-for-category-by-id: (category-id, is-choose)!->
		if is-choose
			@all-category-doms[category-id].add-class "choose"
		else
			@all-category-doms[category-id].remove-class "choose"

	change-choose-for-dish: (category-id, dish-id, is-choose)!->
		if is-choose
			@all-dish-doms[category-id][dish-id].add-class "choose"
		else
			@all-dish-doms[category-id][dish-id].remove-class "choose"

	change-title-by-state: (state)!->
		if state is "new" then @title-dom.html "新建子项"
		else @title-dom.html "编辑子项"

	read-from-subitem: (subitem)!->
		@name-dom.val subitem.name
		@remark-dom.val subitem.remark
		@combo-type-select-dom.val subitem.type
		if subitem.type is "static_combo"
			@number-dom.val subitem.price
		else
			@number-dom.val subitem.discount

	reset: !->
		@name-dom.val null
		@remark-dom.val null
		@combo-type-select-dom.val null
		@number-dom.val null

	create-category-elem-dom: !->
		category-elem-dom = $ "<div class='category-elem'></div>"
		return category-elem-dom

	create-category-dom: (category-name)!->
		category-dom = $ "<div class='category-choose choose-elem'></div>"
		category-dom-inner-html = "<div class='choose-elem-wrapper'>
																<div class='choose-elem-container'>
																	<div class='left-part'>
																		<div class='tria-icon'></div>
																		<p>#{category-name}</p>
																	</div>
																	<div class='right-part'>
																		<div class='tick'></div>
																	</div>
																	<div class='clear'></div>
																</div>
															</div>"
		return category-dom.html category-dom-inner-html

	create-dish-list-dom: !->
		dish-list-dom = $ "<ul class='dish-list'></ul>"
		return dish-list-dom

	create-dish-dom: (dish-name)!->
		dish-dom = $ "<li class='dish-choose choose-elem'></li>"
		dish-dom-inner-html = "<div class='choose-elem-wrapper'>
														<div class='choose-elem-container'>
															<div class='left-part'>
																<p>#{dish-name}</p>
															</div>
															<div class='right-part'>
																<div class='tick'></div>
															</div>
															<div class='clear'></div>
														</div>
													</div>"
		return dish-dom.html dish-dom-inner-html

module.exports = SubitemModifyView