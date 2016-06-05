class Header
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@name 							= options.name
		@check-fn 					= options.check-fn
		@special-check-fn 	= options.special-check-fn

	init: !->
		@init-all-prepare!

	init-all-prepare: !->
		@able 							= null

	set-able: (able)!->
		@able = able
		eventbus.emit "model:header:able-change", @name, @able


module.exports = Header