MVCBase = require "./MVCBase.js"

class MBase extends MVCBase
	(options)->
		super options

	init: !->
		@init-all-prepare!
		@init-all-datas!
		@set-default-state!

	init-all-prepare: !->

	init-all-datas: !->

	set-default-state: !->

	get-datas: -> return @datas

	clear-datas: !-> @datas = null

module.exports = MBase