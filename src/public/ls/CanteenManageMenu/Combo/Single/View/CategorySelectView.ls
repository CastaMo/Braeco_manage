eventbus = require "../eventbus.js"

class CategorySelectView
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@category-controller 	= options.category-controller
		@$el 									= $ options.el-CSS-selector

	init: !->
		@render-all-dom!
		@init-all-event!

	render-all-dom: !->
		categories = @category-controller.get-all-categories!
		for key, category of categories
			dom = $ "<option value='#{category.get-name!}'>#{category.get-name!}</option>"
			@$el.append dom

	init-all-event: !->
		@$el.change !~> @category-controller.set-current-category-id-by-name @$el.val!

module.exports = CategorySelectView