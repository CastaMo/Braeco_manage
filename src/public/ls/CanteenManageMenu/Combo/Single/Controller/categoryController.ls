category = require "../Model/category.js"
eventbus = require "../eventbus.js"

[		deep-copy] = 
	[	util.deep-copy]

class categoryController
	(options)->
		deep-copy options, @
		@init!

	init: !->
		@init-all-prepare!

	init-all-prepare: !->
		@categories 								= {}
		@current-category-id 				= null
		@category-map-name-to-id 		= {}

	set-current-category-by-name: (category-name)!->
		category-id 					= @category-map-name-to-id[category-name]
		@current-category-id 	=  category-id
		eventbus.emit("controller:category:toggle-current-category-id", category-id)