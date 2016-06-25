MVCBase = require "./MVCBase.js"

class CBase extends MVCBase
	(options)->
		super options

	init: !->
		@init-all-prepare!

	init-all-prepare: !->

module.exports = CBase