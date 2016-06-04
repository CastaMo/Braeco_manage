eventbus = require "../eventbus"

[		deep-copy] = 
	[	util.deep-copy]

class category extends EventEmitter2

	(options)->
		deep-copy options, @
		@init!

	init: !->
		@init-all-prepare!
		@add-listen-for-event-bus!

	init-all-prepare: !->
		@categories = {}
	