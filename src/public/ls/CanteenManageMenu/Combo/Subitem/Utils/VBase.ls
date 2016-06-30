Base = require "./Base.js"

class VBase extends Base
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