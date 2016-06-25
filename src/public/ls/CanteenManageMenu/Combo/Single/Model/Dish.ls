class Dish
	(options)!->
		@assign options

	assign: (options)!->
		@id 		=	options.id
		@name 	= options.name


module.exports = Dish