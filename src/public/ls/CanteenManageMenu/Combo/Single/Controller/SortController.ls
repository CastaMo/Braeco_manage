Dish 			= require "../Model/Dish.js"
eventbus 	= require "../eventbus.js"
require_ 	= require "../requireManage.js"


class SortController
	(options)->
		@assign options
		@init!

	assign: (options)!->


	init: !->
		@init-all-prepare!

	init-all-prepare: !->
		@dishes 							= []
		@current-dish-indexes = []

	top-for-current-dishes: !->
		for index in @current-dish-indexes when index isnt 0
			@swap-dish index - 1, index
		@current-dish-indexes.length = 0
		for dish, i in @dishes when dish.is-choose
			@current-dish-indexes.push i
		eventbus.emit "controller:sort:dishes-update", @dishes
		eventbus.emit "controller:sort:current-dish-indexes-change", @current-dish-indexes

	down-for-current-dishes: !->
		while @current-dish-indexes.length isnt 0
			index = @current-dish-indexes.pop!
			if Number(index) is Number(@dishes.length - 1) then continue
			@swap-dish index, index + 1
		@current-dish-indexes.length = 0
		for dish, i in @dishes when dish.is-choose
			@current-dish-indexes.push i
		eventbus.emit "controller:sort:dishes-update", @dishes
		eventbus.emit "controller:sort:current-dish-indexes-change", @current-dish-indexes

	swap-dish: (a-index, b-index)!->
		if a-index is b-index then return
		if @dishes[a-index].is-choose and @dishes[b-index].is-choose then return
		t 								= @dishes[a-index]
		@dishes[a-index] 	= @dishes[b-index]
		@dishes[b-index] 	= t

	set-is-choose: (index, is-choose)!->
		@dishes[index].is-choose = is-choose
		@current-dish-indexes.length = 0
		for dish, i in @dishes when dish.is-choose
			@current-dish-indexes.push i
		eventbus.emit "controller:sort:current-dish-indexes-change", @current-dish-indexes

	get-is-choose: (index)!-> return @dishes[index].is-choose

	get-dishes-id: -> return [dish.id for dish in @dishes]

	reset: !->
		@dishes.length = 0; @current-dish-indexes.length = 0
		eventbus.emit "controller:sort:reset"

	read-from-dishes: (dishes)!->
		@reset!
		for dish in dishes
			dish_ = new Dish dish
			dish_.is-choose = false
			@dishes.push dish_
		eventbus.emit "controller:sort:read-from-dishes", @dishes

	require-for-sort: (dish-ids, callback)!->
		eventbus.emit "view:page:cover-page", "loading"
		require_.get("sort").require {
			data 			:				{
				JSON 		:				JSON.stringify(dish-ids)
			}
			success 	:				callback
			always 		:				!-> eventbus.emit "view:page:cover-page", "exit"
		}


module.exports = SortController