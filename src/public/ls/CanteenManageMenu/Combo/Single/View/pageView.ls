eventbus = require "../eventbus.js"

[		deep-copy] = 
	[	util.deep-copy]

class pageView
	(options)->
		deep-copy options, @
		@init!

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

module.exports = pageView
