eventbus = require "../eventbus.js"

class HeaderView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@header-controller  	= options.header-controller
		@$el 									= $ options.el-CSS-selector
		@all-default-states 	= options.all-default-states

	init: !->
		@init-all-prepare!
		@render-all-dom!
		@init-all-event!
		@set-default-state!

	init-all-prepare: !->
		@all-header-doms 			= {}

	render-all-dom: !->
		datas = @header-controller.datas
		for name in datas
			header-dom = @$el.find "\##{name}"
			@all-header-doms[name] = header-dom

	init-all-event: !->
		eventbus.on "controller:header:able-change", (all-check-results)!~>
			@show-able-for-headers-dom-by-all-check-results all-check-results

		eventbus.on "controller:header:combo-able-change", (combo-able)!~>
			@show-combo-able combo-able

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