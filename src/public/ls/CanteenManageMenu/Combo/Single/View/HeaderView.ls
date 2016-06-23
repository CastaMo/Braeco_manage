eventbus = require "../eventbus.js"

class HeaderView

	all-headers-click-event = 
		"new" 					:		!->
			@new-controller.reset!
			eventbus.emit "view:page:toggle-page", "new"
		"edit" 					:		!->
			@edit-controller.reset!
			current-category-id = @category-controller.get-current-category-id!
			current-combo-id 		= @combo-controller.get-current-combo-ids![0]
			current-combo 			= @combo-controller.get-combo current-category-id, current-combo-id
			@edit-controller.read-from-combo current-combo
			eventbus.emit "view:page:toggle-page", "edit"
		"move" 					:		!->
			eventbus.emit "view:page:cover-page", "move"
		"sort" 					:		!->
			current-category-id = @category-controller.get-current-category-id!
			dishes = null
			datas = @combo-controller.get-datas!
			for data in datas when current-category-id is data.id
				dishes = data.dishes; break
			if dishes.length <= 1 then alert "餐品数量小于2个, 请先添加餐品"; return
			@sort-controller.read-from-dishes dishes
			eventbus.emit "view:page:cover-page", "sort"
		"copy" 					:		!->
			eventbus.emit "view:page:cover-page", "copy"
		"able" 					:		!->
			current-category-id 	= @category-controller.get-current-category-id!
			combo-able 						= @header-controller.get-combo-able!
			@combo-controller.require-for-set-able-for-current-combos current-category-id, !combo-able
		"remove" 				:		!->
			if not confirm "确定要删除套餐吗?(此操作无法恢复)" then return
			current-category-id 	= @category-controller.get-current-category-id!
			@combo-controller.require-for-remove-for-current-combos current-category-id

	(options)->
		@assign options
		@init!

	assign: (options)!->
		@category-controller 	= options.category-controller
		@combo-controller 		= options.combo-controller
		@header-controller  	= options.header-controller
		@new-controller 			= options.new-controller
		@edit-controller 			= options.edit-controller
		@sort-controller 			= options.sort-controller
		@$el 									= $ options.el-CSS-selector
		@all-default-states 	= options.all-default-states

	init: !->
		@init-all-prepare!
		@render-all-dom!
		@init-all-event!
		@set-default-state!

	init-all-prepare: !->
		@all-header-doms 				= {}
		@all-headers-click-event = {}

	render-all-dom: !->
		datas = @header-controller.datas
		for name in datas
			header-dom = @$el.find "\##{name}"
			@all-header-doms[name] 					= header-dom
			@all-headers-click-event[name] 	= all-headers-click-event[name].bind @

	init-all-event: !->
		eventbus.on "controller:header:able-change", (all-check-results)!~>
			@show-able-for-headers-dom-by-all-check-results all-check-results

		eventbus.on "controller:header:combo-able-change", (combo-able)!~>
			@show-combo-able combo-able

		for let header-name, header-dom of @all-header-doms
			header-dom.click !~> if is-able = @header-controller.get-able header-name
				@all-headers-click-event[header-name]?!


	set-default-state: !->
		first = @all-default-states.shift!
		@show-able-for-headers-dom-by-all-check-results first

	show-able-for-headers-dom-by-all-check-results: (all-check-results)!->
		for result in all-check-results
			if result.able then @all-header-doms[result.name].remove-class "disabled"
			else @all-header-doms[result.name].add-class "disabled"

	show-combo-able: (combo-able)!->
		if combo-able then @all-header-doms["able"]	.find "p" .html "售罄"
		else @all-header-doms["able"] .find "p" .html "显示"

module.exports = HeaderView