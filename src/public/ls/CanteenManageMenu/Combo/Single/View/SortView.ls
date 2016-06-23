eventbus = require "../eventbus.js"

class SortView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@$el 							= $ options.el-CSS-selector
		@sort-controller 	= options.sort-controller

	init: !->
		@init-all-prepare!
		@init-all-event!

	init-all-prepare: !->
		@dish-list-dom 					= @$el.find "ul.dish-list"
		@all-dish-doms 					= []
		@close-btn-dom 					= @$el.find ".close-btn"
		@cancel-btn-dom 				= @$el.find ".cancel-btn"
		@confirm-btn-dom 				= @$el.find ".confirm-btn"
		@up-btn-dom 						= @$el.find ".up-btn"
		@down-btn-dom 					= @$el.find ".down-btn"

	init-all-event: !->
		@close-btn-dom.click !~> @close-event!

		@cancel-btn-dom.click !~> @close-event!

		@confirm-btn-dom.click !~> @confirm-btn-click-event!

		@up-btn-dom.click !~> @up-btn-click-event!

		@down-btn-dom.click !~> @down-btn-click-event!

		eventbus.on "controller:sort:dishes-update", (dishes)!~> @update-all-dish-doms dishes

		eventbus.on "controller:sort:current-dish-indexes-change", (current-dish-indexes)!~> @show-choose-for-dish-doms-by-current-dish-indexes current-dish-indexes

		eventbus.on "controller:sort:read-from-dishes", (dishes)!~> @render-all-doms-by-dishes dishes

		eventbus.on "controller:sort:reset", !~> @reset!

	close-event: !-> eventbus.emit "view:page:cover-page", "exit"

	confirm-btn-click-event: !->
		dishes-id = @sort-controller.get-dishes-id!
		@sort-controller.require-for-sort dishes-id, (result)!-> window.location.reload!

	up-btn-click-event: !-> @sort-controller.top-for-current-dishes!

	down-btn-click-event: !-> @sort-controller.down-for-current-dishes!

	update-all-dish-doms: (dishes)!->
		for dish, i in dishes
			@all-dish-doms[i]	.find "p"
												.html dish.name

	show-choose-for-dish-doms-by-current-dish-indexes: (current-dish-indexes)!->
		for dish-dom in @all-dish-doms
			dish-dom.remove-class "choose"
		for index in current-dish-indexes
			@all-dish-doms[index].add-class "choose"

	render-all-doms-by-dishes: (dishes)!->
		for let dish, i in dishes
			dish-dom = @create-dish-dom dish.name
			dish-dom.click !~>
				is-choose = @sort-controller.get-is-choose i
				@sort-controller.set-is-choose i, !is-choose
			@all-dish-doms.push dish-dom
			@dish-list-dom.append dish-dom

	reset: !->
		for dish-dom in @all-dish-doms
			dish-dom.remove!
		@all-dish-doms.length = 0

	create-dish-dom: (dish-name)!->
		dish-dom = $ "<li class='dish'></li>"
		dish-dom-inner-html = "<div class='basic-info'>
														<div class='basic-info-wrapper'>
															<div class='left-part'>
																<div class='name-field'>
																	<p>#{dish-name}</p>
																</div>
															</div>
															<div class='right-part'>
																<div class='tick-field'>
																	<div class='tick'></div>
																</div>
															</div>
															<div class='clear'></div>
														</div>
													</div>"
		return dish-dom.html dish-dom-inner-html

module.exports = SortView