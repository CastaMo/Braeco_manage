Category = require "../Model/Category.js"
eventbus = require "../eventbus.js"

class CategoryController
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@datas = options.datas

	init: !->
		@init-all-prepare!
		@init-all-data!

	init-all-prepare: !->
		@categories 								= {}
		@current-category-id 				= null
		@category-map-name-to-id 		= {}

	init-all-data: !->
		for data in @datas
			category = new Category data
			if not @current-category-id then @current-category-id = category.id
			@category-map-name-to-id[category.name] = category.id
			@categories[category.id] = category

	set-current-category-id-by-name: (category-name)!->
		old-category-id 			= @current-category-id
		category-id 					= @get-category-id-by-name category-name
		@current-category-id 	=  category-id
		eventbus.emit "controller:category:current-category-id-change", category-id, old-category-id

	get-category-id-by-name: (category-name)-> return @category-map-name-to-id[category-name]

	get-current-category-id: -> return @current-category-id

	get-datas: -> return @datas

	clear-datas: !-> @datas = null

module.exports = CategoryController