eventbus = require "../eventbus.js"

class PageView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@all-default-states = options.all-default-states
		@datas 							= options.datas
		@full-cover-dom 		= $ options.full-cover-CSS-selector

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

		for cover-name in @datas.cover
			@all-cover-doms[cover-name] = @full-cover-dom.find ".#{cover-name}-field"

	set-default-state: !->
		for default-state in @all-default-states
			$ default-state.view .add-class default-state.class-name

	add-listen-for-event-bus: !->
		eventbus.on "view:page:toggle-page", (toggle-name)!~> @toggle-page toggle-name

		eventbus.on "view:page:cover-page", (cover-name)!~> @cover-page cover-name


	toggle-page: (toggle-name)!->
		@toggle-state = toggle-name
		for toggle-name_, toggle-dom of @all-toggle-doms when toggle-name isnt toggle-name_
			toggle-dom.fade-out 100
		set-timeout (!~> @all-toggle-doms[toggle-name].fade-in 100), 100
		$("html, body").animate({ scrollTop: 0 }, "fast")

	cover-page: (cover-name)!->
		@cover-state = cover-name
		if cover-name is "exit"
			@full-cover-dom.fade-out 100, !~> if @cover-state is "exit" then @unshow-all-cover-page cover-name
		else @unshow-all-cover-page cover-name; @full-cover-dom.fade-in 100, !~> @all-cover-doms[cover-name].remove-class "hide"

	unshow-all-cover-page: (cover-name)!->
		for cover-name_, cover-dom of @all-cover-doms when cover-name isnt cover-name_
			cover-dom.add-class "hide"

module.exports = PageView
