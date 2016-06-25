Combo 		= require "../Model/Combo.js"
eventbus 	= require "../eventbus.js"
require_ 	= require "../requireManage.js"

class ComboController
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@datas = options.datas

	init: !->
		@init-all-prepare!
		@init-all-datas!
		@init-all-event!

	init-all-prepare: !->
		@combos 							= {}
		@current-combo-ids 		= []
		@current-combo-ables 	= []
		@is-all-choose 				= false

	init-all-datas: !->
		for data in @datas
			category-id = data.id
			@combos[category-id] = []
			for dish in data.dishes
				if dish.type isnt "normal"
					combo 							= new Combo dish
					combo.is-choose 		= false
					@combos[category-id].push combo

	init-all-event: !->
		eventbus.on "controller:category:current-category-id-change", (category-id, old-category-id)!~>
			@set-is-all-choose old-category-id, false

		eventbus.on "controller:new:add-combo", (category-id, config-data)!~>
			@add-combo category-id, config-data
			@set-is-all-choose category-id, false

		eventbus.on "controller:edit:edit-combo", (category-id, combo-id, config-data)!~> @edit-combo category-id, combo-id, config-data

	get-current-combo-ids: -> return @current-combo-ids

	get-combo: (category-id, combo-id)->
		for combo in @combos[category-id]
			if Number(combo-id) is Number(combo.get-id!) then return combo

	get-combo-is-choose: (category-id, combo-id)->
		for combo in @combos[category-id]
			if Number(combo-id) is Number(combo.get-id!) then return combo.is-choose

	set-is-choose: (category-id, combo-id, is-choose)!->
		@current-combo-ids.length 		= 0
		@current-combo-ables.length 	= 0
		for combo in @combos[category-id]
			if Number(combo-id) is Number(combo.get-id!) then combo.is-choose = is-choose
			if combo.is-choose
				@current-combo-ids.push combo.get-id!
				@current-combo-ables.push combo.get-able!
		eventbus.emit "controller:combo:current-combo-ids-change", @current-combo-ids, @current-combo-ables

	set-all-is-choose-by-category-id: (category-id, is-choose)!->
		@current-combo-ids.length 		= 0
		@current-combo-ables.length 	= 0
		for combo in @combos[category-id]
			combo.is-choose = is-choose
			if combo.is-choose
				@current-combo-ids.push combo.get-id!
				@current-combo-ables.push combo.get-able!
		eventbus.emit "controller:combo:current-combo-ids-change", @current-combo-ids, @current-combo-ables

	get-is-all-choose: -> return @is-all-choose

	set-is-all-choose: (category-id, is-all-choose)->
		@is-all-choose = is-all-choose
		@set-all-is-choose-by-category-id category-id, is-all-choose
		eventbus.emit "controller:combo:is-all-choose-change", @is-all-choose

	set-config-for-combo: (category-id, combo-id, config-data)!->
		for combo in @combos[category-id] when Number(combo-id) is Number(combo.id)
			combo.set-config config-data
			eventbus.emit "controller:combo:edit-combo", category-id, combo-id


	#========= operation for combo start ===============#
	set-able-for-current-combos: (category-id, able)!->
		for combo in @combos[category-id] when combo.id in @current-combo-ids
			combo.set-able able
			eventbus.emit "controller:combo:set-able", category-id, combo.id
		@set-is-all-choose category-id, false

	remove-for-current-combos: (category-id)!->
		temp = []
		for combo in @combos[category-id] when combo.id in @current-combo-ids
			temp.push combo
		category-for-combos = @combos[category-id]
		for combo in temp
			category-for-combos.splice (category-for-combos.index-of combo), 1
			eventbus.emit "controller:combo:remove", category-id, combo.id
		temp = null
		@set-is-all-choose category-id, false

	add-combo: (category-id, config-data)!->
		combo 					= new Combo config-data
		combo.is-choose = false
		@combos[category-id].push combo
		eventbus.emit "controller:combo:add-combo", category-id, combo.id

	remove-combo: (category-id, combo-id)!->
		combo = @get-combo category-id, combo-id
		category-for-combos = @combos[category-id]
		category-for-combos.splice (category-for-combos.index-of combo), 1
		eventbus.emit "controller:combo:remove", category-id, combo-id

	edit-combo: (category-id, combo-id, config-data)!->
		@set-config-for-combo category-id, combo-id, config-data
		@set-is-all-choose category-id, false

	copy-combo: (old-category-id, new-category-id, old-combo-id, new-combo-id)!->
		old-combo = @get-combo old-category-id, old-combo-id
		new-combo-config = old-combo.get-copy-config-for-construct!
		new-combo-config.id = new-combo-id
		@add-combo new-category-id, new-combo-config

	move-combo: (old-category-id, new-category-id, old-combo-id)!->
		old-combo = @get-combo old-category-id, old-combo-id
		new-combo-config = old-combo.get-copy-config-for-construct!
		@remove-combo old-category-id, old-combo-id
		@add-combo new-category-id, new-combo-config


	#========= operation for combo end ===============#

	require-for-set-able-for-current-combos: (category-id, able)!->
		if able then flag = 1
		else flag = 0
		eventbus.emit "view:page:cover-page", "loading"
		require_.get("able").require {
			data 			: 			{
				JSON		: 			JSON.stringify(@current-combo-ids)
				flag 		:				flag				
			}
			success 	:				(result)!~> @set-able-for-current-combos category-id, able
			always 		:				!-> eventbus.emit "view:page:cover-page", "exit"
		}

	require-for-remove-for-current-combos: (category-id)!->
		eventbus.emit "view:page:cover-page", "loading"
		require_.get("remove").require {
			data 			: 			{
				JSON 		:				JSON.stringify(@current-combo-ids)
			}
			success 	: 			(result)!~> @remove-for-current-combos category-id
			always 		:				!-> eventbus.emit "view:page:cover-page", "exit"
		}


	get-datas: -> return @datas

	clear-datas: !-> @datas = null

module.exports = ComboController