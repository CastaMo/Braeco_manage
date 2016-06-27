MBase 		= require "../Utils/MBase.js"
eventbus 	= require "../eventbus.js" 

class PageModel extends MBase
	(options)->
		super options

	assign: (options)!->
		@datas = options.datas
		@all-default-states = options.all-default-states

	init-all-perpare: !->
		@current-toggle-state 	= null
		@current-cover-state 		= null

	set-default-state: !->
		for attr, value of @all-default-states
			@["current-#{attr}"] = value

	toggle-change: (toggle-name)!->
		@current-toggle-state = toggle-name
		eventbus.emit "model:page:toggle-change", toggle-name

	cover-change: (cover-name)!->
		@current-cover-state = cover-name
		eventbus.emit "model:page:cover-change", cover-name

	get-toggle-state: -> return @current-toggle-state

	get-cover-state: -> return @current-cover-state

module.exports = PageModel
