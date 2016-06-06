eventbus = require "../eventbus.js"

class HeaderView

	all-headers-click-event = 
		"new" 					:		!->
			eventbus.emit "view:page:toggle-page", "new"
		"edit" 					:		!-> 
		"move" 					:		!-> 
		"sort" 					:		!->
		"copy" 					:		!-> 
		"able" 					:		!->
			current-category-id 	= @category-controller.get-current-category-id!
			combo-able 						= @header-controller.get-combo-able!
			@combo-controller.set-able-for-current-combos current-category-id, !combo-able
		"remove" 				:		!->
			current-category-id 	= @category-controller.get-current-category-id!
			@combo-controller.remove-for-current-combos current-category-id

	(options)->
		@assign options
		@init!

	assign: (options)!->
		@category-controller 	= options.category-controller
		@combo-controller 		= options.combo-controller
		@header-controller  	= options.header-controller
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