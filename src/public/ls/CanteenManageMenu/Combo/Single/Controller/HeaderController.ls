eventbus 			= require "../eventbus.js"

class HeaderController
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@datas = options.datas

	init: !->
		@init-all-prepare!
		@init-all-data!
		@init-all-event!

	init-all-prepare: !->
		@all-headers = {}
		



module.exports = HeaderController