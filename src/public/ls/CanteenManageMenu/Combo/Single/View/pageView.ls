eventbus = require "../eventbus.js"

class PageView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@all-default-states = options.all-default-states

	init: !->
		@init-all-dom!
		@add-listen-for-event-bus!

	init-all-dom: !->
		@get-view-dom!
		@set-default-state!

	get-view-dom: !->

	set-default-state: !->
		for default-state in @all-default-states
			$ default-state.view .add-class default-state.class-name

	add-listen-for-event-bus: !->
		eventbus.on "view:page:toggle-page", (page)!~>
			

	toggle-page-callback: (page)!->

module.exports = PageView
