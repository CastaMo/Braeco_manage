eventbus 			= require "../eventbus.js"
Header 				= require "../Model/Header.js"

class HeaderController

	all-header-check-fn = {
		"new" 			: 	(current-combo-ids)-> return true
		"edit" 			:		(current-combo-ids)-> return current-combo-ids.length is 1
		"move" 			:		(current-combo-ids)-> return current-combo-ids.length >= 1
		"sort" 			:		(current-combo-ids)-> return true
		"copy" 			:		(current-combo-ids)-> return current-combo-ids.length >= 1
		"able" 			:		(current-combo-ids, current-combo-ables)->
			if current-combo-ids.length is 0 then return false
			able_ = current-combo-ables[0]
			for able in current-combo-ables
				if able isnt able_ then return false
			return true
		"remove" 		:		(current-combo-ids)-> return current-combo-ids.length >= 1
	}

	(options)->
		@assign options
		@init!

	assign: (options)!->
		@datas 								= options.datas
		@all-default-states 	= options.all-default-states 

	init: !->
		@init-all-prepare!
		@init-all-data!
		@init-all-event!
		@set-default-state!

	init-all-prepare: !->
		@all-headers 					= {}
		@all-check-results 		= []
		@combo-able 					= null

	init-all-data: !->
		for name in @datas
			header = new Header opt =
				name 		 						:		name
				check-fn 						: 	all-header-check-fn[name]
			header.able 							= null
			@all-headers[header.name] = header

	init-all-event: !->
		eventbus.on "controller:combo:current-combo-ids-change", (current-combo-ids, current-combo-ables) !~>
			@check-all-headers current-combo-ids, current-combo-ables
			if @all-headers["able"].able then @check-combo-able current-combo-ables[0]

	set-default-state: !->
		first = @all-default-states.shift!
		[current-combo-ids, current-combo-ables] = [first.current-combo-ids, first.current-combo-ables]
		@check-all-headers current-combo-ids, current-combo-ables
		@check-combo-able current-combo-ables[0]

	
	check-all-headers: (current-combo-ids, current-combo-ables)!->
		@all-check-results.length = 0
		for header-name, header of @all-headers
			header.able = header.check-fn current-combo-ids, current-combo-ables
			@all-check-results.push {name: header.name, able: header.able}
		eventbus.emit "controller:header:able-change", @all-check-results

	check-combo-able: (combo-able)!->
		@combo-able = combo-able
		eventbus.emit "controller:header:combo-able-change", @combo-able

	get-datas: -> return @datas

	clear-datas: !-> @datas = null


module.exports = HeaderController