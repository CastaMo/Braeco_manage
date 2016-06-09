class Header
	(options)->
		@assign options

	assign: (options)!->
		@name 							= options.name
		@check-fn 					= options.check-fn


module.exports = Header