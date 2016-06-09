class Subitem
	(options)->
		@assign options

	assign: (options)!->
		@id 					= 	Number options.id
		@name 				= 	options.name
		@price 				= 	Number options.price 		|| 0
		@remark 			= 	options.remark 					|| ""
		@type 				= 	options.type
		@content 			= 	options.content 				|| []
		@belong-to		= 	options.belong_to 			|| []

	get-name: -> return @name

	get-price: -> return @price

	get-id: -> return @id

	get-remark: -> return @remark

	get-type: -> return @type

	get-content: -> return @content

	get-belong-to: -> return @belong-to

module.exports = Subitem