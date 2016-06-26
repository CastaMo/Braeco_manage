MVCBase = require "./MVCBase.js"

class VBase extends MVCBase
	(options)->
		super options

	init: !->
		@init-all-prepare!
		@init-all-dom!
		@init-all-event!
		@set-default-state!

	init-all-prepare: !->

	init-all-dom: !->

	init-all-event: !->

	set-default-state: !->

module.exports = VBase