Combo 						= require "../Model/Combo"

class ComboController
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@datas = options.datas

	init: !->
		@init-all-prepare!
		@init-all-data!

	init-all-prepare: !->
		@combos = {}
		@current-combo-ids = []

	init-all-data: !->
		for data in @datas
			category-id = data.id
			@combos[category-id] = []
			for dish in data.dishes
				if dish.type isnt "normal"
					combo = new Combo dish
					@combos[category-id].push combo
		# 及时清除以释放内存
		@datas = null

	get-all-combos: -> return @combos

module.exports = ComboController