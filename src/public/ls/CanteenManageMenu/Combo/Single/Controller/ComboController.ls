Combo 		= require "../Model/Combo"
eventbus 	= require "../eventbus"

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

	#========= operation for combo start ===============#
	set-able-for-current-combos: (category-id, able)!->
		for combo in @combos[category-id] when combo.id in @current-combo-ids
			combo.set-able able
			eventbus.emit "controller:combo:set-able", category-id, combo.id
		@set-is-all-choose category-id, false

	remove-for-current-combos: (category-id)!->
		if not confirm "确定要删除套餐吗?(此操作无法恢复)" then return
		temp = []
		for combo in @combos[category-id] when combo.id in @current-combo-ids
			temp.push combo
		category-for-combos = @combos[category-id]
		for combo in temp
			category-for-combos.splice (category-for-combos.index-of combo), 1
			eventbus.emit "controller:combo:remove", category-id, combo.id
		temp = null
		@set-is-all-choose category-id, false

	#========= operation for combo end ===============#

	get-datas: -> return @datas

	clear-datas: !-> @datas = null

module.exports = ComboController