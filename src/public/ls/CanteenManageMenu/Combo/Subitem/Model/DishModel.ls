MBase 		= require "../Utils/MBase.js"
Base 			= require "../Utils/Base.js"


class Dish extends Base
	(options)-> super options

	assign: (options)!->
		@name 	= options.name
		@type 	= options.type
		@id 		= Number options.id

class Category extends Base
	(options)-> super options

	assign: (options)!->
		@name 	= options.name
		@id 		= Number options.id

class DishModel extends MBase
	(options)-> super options

	assign: (options)!->
		@datas = options.datas

	init-all-prepare: !->
		@all-dishes 			= {}
		@all-categories 	= {}

	init-all-datas: !->
		for data in @datas when data.dishes.length > 0
			category = new Category {
				id 		 	: 		data.id
				name 		: 		data.name
			}
			@all-dishes[category.id] 			= {}
			@all-categories[category.id] 	= category
			for dish in data.dishes when dish.type is "normal"
				dish_ = new Dish {
					id 		: 		dish.id
					name 	: 		dish.name
					type 	: 		dish.type
				}
				@all-dishes[category.id][dish.id] = dish_

	get-category-id-by-dish-id: (dish-id)->
		for category-id, category of @all-dishes
			if category[dish-id] then return category-id

module.exports = DishModel
