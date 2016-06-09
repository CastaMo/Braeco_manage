eventbus = require "../eventbus.js"

class PageView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@all-default-states = options.all-default-states
		@datas 							= options.datas

	init: !->
		@init-all-prepare!
		@init-all-dom!
		@add-listen-for-event-bus!

	init-all-prepare: !->
		@all-toggle-doms 		= {}
		@toggle-state 			= null
		@all-cover-doms 		= {}
		@cover-state 				= null

	init-all-dom: !->
		@get-view-dom!
		@set-default-state!

	get-view-dom: !->
		for toggle-name in @datas.toggle
			@all-toggle-doms[toggle-name] = $ "\#combo-#{toggle-name}"

	set-default-state: !->
		for default-state in @all-default-states
			$ default-state.view .add-class default-state.class-name

	add-listen-for-event-bus: !->
		eventbus.on "view:page:toggle-page", (toggle-name)!~> @toggle-page toggle-name

		eventbus.on "view:page:cover-page", (toggle-name)!~> @toggle-page toggle-name
		

	toggle-page: (toggle-name)!->
		@toggle-state = toggle-name
		for toggle-name_, toggle-dom of @all-toggle-doms when toggle-name isnt toggle-name_
			toggle-dom.fade-out 100
		set-timeout (!~> @all-toggle-doms[toggle-name].fade-in 100), 100

	cover-page: (cover-name)!->
		@cover-state = cover-name
		for cover-name_, cover-dom of @all-cover-doms when cover-name isnt cover-name_
			cover-dom.add-class "hide"
		if cover-name is "exit" then @full-cover-dom.fade-out 100
		else @all-cover-doms[cover-name].remove-class "hide"; @full-cover-dom.fade-in 100

module.exports = PageView
