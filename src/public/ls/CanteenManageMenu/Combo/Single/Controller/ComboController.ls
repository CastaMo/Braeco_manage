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
		@init-all-data!
		@init-all-event!

	init-all-prepare: !->
		@combos 						= {}
		@current-combo-ids 	= []
		@is-all-choose 			= false

	init-all-data: !->
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
			if Number(combo-id) is Number(combo.id) then return combo

	get-combo-is-choose: (category-id, combo-id)->
		for combo in @combos[category-id]
			if Number(combo-id) is Number(combo.id) then return combo.is-choose

	set-is-choose: (category-id, combo-id, is-choose)!->
		@current-combo-ids.length = 0
		for combo in @combos[category-id]
			if Number(combo-id) is Number(combo.id) then combo.is-choose = is-choose
			if combo.is-choose then @current-combo-ids.push combo.id
		eventbus.emit "controller:combo:current-combo-ids-change", @current-combo-ids

	set-all-is-choose-by-category-id: (category-id, is-choose)!->
		@current-combo-ids.length = 0
		for combo in @combos[category-id]
			combo.is-choose = is-choose
			if is-choose then @current-combo-ids.push combo.id
		eventbus.emit "controller:combo:current-combo-ids-change", @current-combo-ids

	get-is-all-choose: -> return @is-all-choose

	set-is-all-choose: (category-id, is-all-choose)->
		@is-all-choose = is-all-choose
		@set-all-is-choose-by-category-id category-id, is-all-choose
		eventbus.emit "controller:combo:is-all-choose-change", @is-all-choose

	get-datas: -> return @datas

	clear-datas: !-> @datas = null

module.exports = ComboController