Base = require "./Base.js"

class CBase extends Base
	(options)->
		super options

	init: !->
		@init-all-prepare!

	init-all-prepare: !->

module.exports = CBase