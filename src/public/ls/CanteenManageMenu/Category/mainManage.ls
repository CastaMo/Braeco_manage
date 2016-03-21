page = require "./pageManage.js"
main-manage = let
	[deep-copy, getJSON] 	=	 [util.deep-copy, util.getJSON]

	_categories = {}

	_init-all-category = (_get-category-JSON)!->
		all-categories = getJSON _get-category-JSON!
		for category, i in all-categories
			category_ = new Category {
				id 		:	category.categoryid
				name	:	category.categoryname
				pic 	:	category.categorypic
				isHead	:	category.isHead || false
			}

	_init-all-event = !->
		($ "\#category-main \#new-btn").click !->
				page.toggle-page "new"

	class Category
		_category-main-container-dom = $ "\#category-main .category-all-field \#t-body-field"
		(options)!->
			deepCopy options, @
			@init!
			_categories[@id] = @

		init: !->
			@init-dom!
			@init-all-event!

		init-all-event: !->
			(@dom.find ".remove").click !~> if confirm "确定要删除品类吗?(此操作无法恢复)" then @remove-self!
			(@dom.find ".top").click !~> @top-self!

		init-dom: !->
			_get-category-dom = (category)->
				dom = $ "<div></div>"; dom.attr {"class":'t-body category'}
				innerHTML = "<div class='t-first'>
									<p>#{category.name}</p>
								</div>
								<div class='t-second'>
									<div class='food-pic-field'>
										<div class='img default-category-image' #{if category.pic then "style=background-image:url(#{category.pic})" else ""}></div>
									</div>
								</div>
								<div class='t-third'>
									<div class='oper-field'>
										<div class='edit'>
											<p>修改</p>
										</div>
										<div class='remove'>
											<p>删除</p>
										</div>
										<div class='top'>
											<p>置顶</p>
										</div>
										<div class='clear'></div>
									</div>
								</div>
								<div class='clear'></div>"
				dom.html innerHTML
				if category.isHead then _category-main-container-dom.prepend dom
				else _category-main-container-dom.append dom
				dom

			@dom = _get-category-dom @

		remove-self: !->
			@dom.fade-out 200, !~>
				@dom.remove!
				delete _categories[@id]

		top-self: !->
			@dom.remove!
			temp = {}; deep-copy @, temp; temp.dom = null
			main-manage.add-new-category {
				name 		:		temp.name
				id 			:		temp.id
				pic 		:		temp.pic
				isHead 		:		true
			}

		edit-self: (options)!->
			if options.name isnt @name
				@name = options.name



	initial: (_get-category-JSON)!->
		_init-all-category _get-category-JSON
		_init-all-event!

	add-new-category: (options)-> category = new Category options

	is-exist-name: (name)->
		[return true for id, category of _categories when category.name is name]
		return false


module.exports = main-manage
