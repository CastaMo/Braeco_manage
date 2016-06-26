eventbus = require "../eventbus.js"

class MoveView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@$el 									= $ options.el-CSS-selector
		@move-controller 			= options.move-controller
		@category-controller 	= options.category-controller
		@combo-controller 		= options.combo-controller

	init: !->
		@init-all-prepare!
		@render-all-dom!
		@init-all-event!

	init-all-prepare: !->
		@all-select-option-doms = {}
		@select-dom 						= @$el.find "select"
		@close-btn-dom 					= @$el.find ".close-btn"
		@cancel-btn-dom 				= @$el.find ".cancel-btn"
		@confirm-btn-dom 				= @$el.find ".confirm-btn"

	render-all-dom: !->
		datas = @category-controller.get-datas!
		for data in datas
			select-option-dom 								= @create-select-option-dom data.name
			@select-dom.append select-option-dom
			@all-select-option-doms[data.id] 	= select-option-dom

	init-all-event: !->
		@select-dom.change !~> @select-dom-change-event!

		@close-btn-dom.click !~> @close-event!

		@cancel-btn-dom.click !~> @close-event!

		@confirm-btn-dom.click !~> @confirm-btn-click-event!


	select-dom-change-event: !->
		current-category-id = @category-controller.get-category-id-by-name @select-dom.val!
		@move-controller.set-current-category-id current-category-id

	close-event: !-> eventbus.emit "view:page:cover-page", "exit"

	confirm-btn-click-event: !->
		current-combo-ids = @combo-controller.get-current-combo-ids!
		current-category-id = @move-controller.get-current-category-id!
		@move-controller.require-for-move current-combo-ids,
																			current-category-id,
																			(result)!~> @success-callback!

	success-callback: !->
		old-category-id = @category-controller.get-current-category-id!
		new-category-id = @move-controller.get-current-category-id!
		current-combo-ids = @combo-controller.get-current-combo-ids!
		for combo-id in current-combo-ids
			@combo-controller.move-combo old-category-id, new-category-id, combo-id
		@combo-controller.set-is-all-choose old-category-id, false
		eventbus.emit "view:page:cover-page", "exit"

	create-select-option-dom: (category-name)!->
		return select-option-dom = $ "<option value='#{category-name}'>#{category-name}</option>"

module.exports = MoveView
