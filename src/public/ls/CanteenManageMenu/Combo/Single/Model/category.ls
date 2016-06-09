eventbus = require "../eventbus"

class Category

	(options)->
		@assign options

	assign: (options)!->
		@id 			= 		options.id
		@name 		= 		options.name
		@pic 			= 		options.pic

	get-name: -> return @name

module.exports = Category