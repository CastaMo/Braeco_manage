eventbus = require "../eventbus.js"

class CategorySelectView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@category-controller 	= options.category-controller
		@$el 									= $ options.el-CSS-selector

	init: !->
		@init-all-prepare!
		@render-all-dom!
		@init-all-event!

	init-all-prepare: !->
		@all-select-option-doms = {}

	render-all-dom: !->
		datas = @category-controller.get-datas!
		for data in datas
			select-option-dom 								= @create-select-option-dom data.name
			@$el.append select-option-dom
			@all-select-option-doms[data.id] 	= select-option-dom

	init-all-event: !->
		@$el.change !~> @category-controller.set-current-category-id-by-name @$el.val!

	create-select-option-dom: (category-name)!->
		return select-option-dom = $ "<option value='#{category-name}'>#{category-name}</option>"

module.exports = CategorySelectView