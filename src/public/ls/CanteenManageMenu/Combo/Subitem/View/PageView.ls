VBase 		= require "../Utils/VBase.js"
eventbus 	= require "../eventbus.js"

class PageView extends VBase
	(options)-> super options

	assign: (options)!->
		@page-model 				= options.page-model
		@page-controller 		= options.page-controller
		@full-cover-dom 		= $ options.full-cover-CSS-selector
		@all-default-states = options.all-default-states

	init-all-prepare: !->
		@all-cover-doms 		= {}
		@all-toggle-doms 		= {}
		@datas 							= @page-model.get-datas!

	init-all-dom: !->
		for toggle-name in @datas.toggle
			@all-toggle-doms[toggle-name] = $ "\#subitem-#{toggle-name}"

		for cover-name in @datas.cover
			@all-cover-doms[cover-name] = @full-cover-dom.find ".#{cover-name}-field"

	init-all-event: !->
		eventbus.on "view:page:toggle-change", (toggle-name)!~> @toggle-page toggle-name

		eventbus.on "view:page:cover-change", (cover-name)!~> @cover-page cover-name

	set-default-state: !->
		for default-state in @all-default-states
			$ default-state.view .add-class default-state.class-name

	toggle-page: (toggle-name)!->
		for toggle-name_, toggle-dom of @all-toggle-doms when toggle-name isnt toggle-name_
			toggle-dom.fade-out 100
		set-timeout (!~> @all-toggle-doms[toggle-name].fade-in 100), 100

	cover-page: (cover-name)!->
		if cover-name is "exit"
			@full-cover-dom.fade-out 100, !~> if @page-controller.get-cover-state! is "exit" then @unshow-all-cover-page cover-name
		else @unshow-all-cover-page cover-name; @full-cover-dom.fade-in 100, !~> @all-cover-doms[cover-name].remove-class "hide"

	unshow-all-cover-page: (cover-name)!->
		for cover-name_, cover-dom of @all-cover-doms when cover-name isnt cover-name_
			cover-dom.add-class "hide"

module.exports = PageView
