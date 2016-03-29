main-manage = let
	_state = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]

	_dishes = {}
	_categories = {}
	_current-category-id = null

	_init-all-food = (_get-food-JSON)->
		all-foods = get-JSON _get-food-JSON!
		for category, i in all-foods
			category_ = new Category {
				seqNum 		:		i
				name 		:		category.categoryname
				id 			:		category.categoryid
			}

	class Category
		_map-category-name-to-id = {}
		_food-single-select-dom = $ "select.food-single-select"
		_single-list-field-dom = $ ".single-list-field"

		(options)!->
			deep-copy options, @
			@init!
			_map-category-name-to-id[@name] = @id
			_categories[@id] = @

		init: !->
			@init-all-dom!

		init-all-dom: !->
			@init-select-option-dom!
			@init-single-list-dom!

		init-select-option-dom: !->
			select-option-dom = $ "<option value='#{@name}'>#{@name}</option>"
			_food-single-select-dom.append select-option-dom

		init-single-list-dom: !->
			_get-single-list-dom = (category)->
				single-list-dom = $ "<ul class='single-list' id='single-list-#{category.seqNum}'></ul>"
				_single-list-field-dom.append single-list-dom
				single-list-dom
			@single-list-dom = _get-single-list-dom @
			

	initial: (_get-food-JSON)!->
		_init-all-food _get-food-JSON

module.exports = main-manage