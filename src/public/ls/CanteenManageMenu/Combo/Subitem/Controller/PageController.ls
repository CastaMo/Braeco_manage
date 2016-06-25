CBase 		= require "../Utils/CBase.js"
eventbus 	= require "../eventbus.js"

class PageController extends CBase
	(options)-> super options

	assign: (options)!->
		@page-model = options.page-model

	toggle-change: (toggle-name)!-> @page-model.toggle-change toggle-name

	cover-change: (cover-name)!-> @page-model.cover-change cover-name

	get-cover-state: -> return @page-model.get-cover-state!

	get-toggle-state: -> return @page-model.get-toggle-state!

module.exports = PageController