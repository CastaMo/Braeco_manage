main 		= null
page 		= null
subItem 	= null
require_ 	= null

new-manage = let

	[		deep-copy] =
		[	util.deep-copy]

	_all-categories = {}
	_all-dishes 		= {}

	_new-dom 						= $ "\#property-new"
	_name-input-dom 				= _new-dom.find ".name-field input"
	_remark-input-dom 				= _new-dom.find ".remark-field input"
	_property-sub-item-list-dom 	= _new-dom.find "ul.content-list"
	_add-sub-item-btn-dom		 	= _new-dom.find ".add-btn"
	_cancel-btn-dom 				= _new-dom.find ".cancel-btn"
	_save-btn-dom 					= _new-dom.find ".save-btn"

	_name 				= null
	_remark 			= null
	_content 			= []

	_new-id 			= null

	_is-all-choose 				= false

	_all-choose-dish-ids 	= []

	_all-choose-dom 				= _new-dom.find ".all-choose"
	_using-dom 							= _new-dom.find ".using-container"


	class Category
		(options)->
			deep-copy options, @
			@init!
			_all-categories[@id] 	= @
			_all-dishes[@id] 			= {}

		_get-category-elem-dom = (category)->
			dom = $ "<div class='category-elem'></div>"
			dom-inner-html = "<div class='category-choose choose-elem'>
													<div class='choose-elem-wrapper'>
														<div class='choose-elem-container'>
															<div class='left-part'>
																<div class='tria-icon'></div>
																<p>#{category.name}</p>
															</div>
															<div class='right-part'>
																<div class='tick'></div>
															</div>
															<div class='clear'></div>
														</div>
													</div>
												</div>
												<ul class='dish-list'></ul>"
			return dom.html dom-inner-html

		init: !->
				@init-all-prepare!
				@init-all-dom!
				@init-all-event!

		init-all-prepare: !->
			@is-choose = false
			@is-active = false

		init-all-dom: !->
			@category-elem-dom 	= _get-category-elem-dom @
			_using-dom.append @category-elem-dom
			@choose-elem-dom 		= @category-elem-dom.find ".choose-elem"
			@dish-list-dom 			= @category-elem-dom.find "ul"

		init-all-event: !->
			@choose-elem-dom.click !~>
				@set-is-active !@is-active

			@category-elem-dom.find(".right-part").click !~>
				is-choose = !@is-choose
				@set-is-choose is-choose
				return false

		set-is-active: (is-active)!->
			@is-active = is-active
			if @is-active
				@choose-elem-dom.add-class "active"
				@dish-list-dom.slide-down!
			else
				@choose-elem-dom.remove-class "active"
				@dish-list-dom.slide-up!

		set-is-choose: (is-choose)!->
			@is-choose = is-choose
			for dish-id, dish of _all-dishes[@id]
				dish.set-is-choose is-choose
			if @is-choose then @choose-elem-dom.add-class "choose"
			else @choose-elem-dom.remove-class "choose"

		@reset = !->
			for category-id, category of _all-categories
				category.set-is-active false

	class Dish

		_get-dish-elem-dom = (dish)->
			dom = $ "<li class='dish-choose choose-elem'></li>"
			dom-inner-html = "<div class='choose-elem-wrapper'>
													<div class='choose-elem-container'>
														<div class='left-part'>
															<p>#{dish.name}</p>
														</div>
														<div class='right-part'>
															<div class='tick'></div>
														</div>
														<div class='clear'></div>
													</div>
												</div>"
			return dom.html dom-inner-html

		(options)->
			deep-copy options, @
			@init!
			_all-dishes[@category-id][@id] = @

		init: !->
			@init-all-prepare!
			@init-all-dom!
			@init-all-event!

		init-all-prepare: !->
			@is-choose = false

		init-all-dom: !->
			@dish-elem-dom = _get-dish-elem-dom @
			_all-categories[@category-id].dish-list-dom.append @dish-elem-dom

		set-is-choose: (is-choose)!->
			@is-choose = is-choose
			if @is-choose then @dish-elem-dom.add-class "choose"
			else @dish-elem-dom.remove-class "choose"

		init-all-event: !->
			@dish-elem-dom.click !~>
				@set-is-choose !@is-choose

		@update-all-choose-dish-ids = !->
			_all-choose-dish-ids := []
			for category-id, category of _all-dishes
				for dish-id, dish of category when dish.is-choose
					_all-choose-dish-ids.push dish-id


	_read-from-input = !->
		_name 			:= _name-input-dom.val!
		_remark 		:= _remark-input-dom.val!
		_content 		:= subItem.get-all-property-sub-items-value!
		Dish.update-all-choose-dish-ids!

	_reset = !->
		subItem.reset!
		_name-input-dom.val ""
		_remark-input-dom.val ""
		_name 		:= null
		_remark 	:= null
		_content 	:= []
		_new-id 	:= null
		_set-is-all-choose false
		set-timeout !->
			Category.reset!
		, 200

	_check-is-valid = ->
		is-ch-code = (num)->
			return num >= 0x4E00 and num <= 0x9FFF

		get-total-length-for-str = (str)->
			count = 0
			for i in [0 to str.length - 1]
				if is-ch-code str.char-code-at i then count += 2
				else count += 1
			return count

		_valid-flag = true; _err-msg = ""
		if get-total-length-for-str(_name) <= 0 or get-total-length-for-str(_name) > 32 then _valid-flag = false; _err-msg += "名字长度应为(1~32)(一个中文字符占2个单位)\n"
		if get-total-length-for-str(_remark) > 32 then _valid-flag = false; _err-msg += "备注长度应为(0~32)(一个中文字符占2个单位)\n"
		for property-sub-item, i in _content
			name = property-sub-item.name
			if get-total-length-for-str(name) <= 0 or get-total-length-for-str(name) > 32 then _valid-flag = false; _err-msg += "第#{i+1}项的名字长度应为(1~32)(一个中文字符占2个单位)\n"
			price = property-sub-item.price
			if price.length is 0 or Number(price) < 0 or Number(price) > 100000 then _valid-flag = false; _err-msg += "第#{i+1}项的价格应为(0~100000)\n"
		if not _valid-flag then alert _err-msg
		return _valid-flag

	_success-callback = !->
		main.add-property {
			id 			:		_new-id
			name 		:		_name
			content 	: 		_content
			belong_to 	:		_all-choose-dish-ids
			remark 		:		_remark
		}
		page.toggle-page "main"
		_reset!

	_get-upload-JSON-for-add = ->
		return JSON.stringify {
			name  		:		_name
			remark 		:		_remark
			type 		:		"property"
			content 	:		_content
			belong_to : 	_all-choose-dish-ids
		}

	_cancel-btn-click-event = !->
		page.toggle-page "main"
		_reset!

	_save-btn-click-event = !->
		_read-from-input!
		if not _check-is-valid! then return
		page.cover-page "loading"
		require_.get("add").require {
			data 		:		{
				JSON 	:		_get-upload-JSON-for-add!
			}
			success 	: 		(result)!-> _new-id := result.id; _success-callback!
			always 		: 		!-> page.cover-page "exit"
		}

	_add-sub-item-btn-click-event = !->
		subItem.add-proprety-sub-item!

	_set-is-all-choose = (is-choose)!->
		_is-all-choose := is-choose
		if _is-all-choose then _all-choose-dom.add-class "choose"
		else _all-choose-dom.remove-class "choose"
		for category-id, category of _all-categories
			category.set-is-choose is-choose

	_all-choose-dom-click-event = !->
		_set-is-all-choose !_is-all-choose

	_init-all-event = !->
		_cancel-btn-dom.click !-> _cancel-btn-click-event!

		_save-btn-dom.click !-> _save-btn-click-event!

		_add-sub-item-btn-dom.click !-> _add-sub-item-btn-click-event!

		_all-choose-dom.click !-> _all-choose-dom-click-event!

	_init-depend-module = !->
		main 		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"
		subItem 	:= require "./subItemManage.js"
		require_ 	:= require "./requireManage.js"

	_init-all-data = (get-menu-JSON)!->
		console.log(get-menu-JSON!)
		all-data = get-menu-JSON!
		for category in all-data
			new Category {
				name 	: 	category.name
				id 		: 	category.id
			}
			for dish in category.dishes when dish.type is "normal" or dish.type is "combo_only"
				new Dish {
					name 				: 	dish.name
					category-id	: 	category.id
					id 					: 	dish.id
				}

	initial: (get-menu-JSON)!->
		_init-all-data get-menu-JSON
		_init-depend-module!
		_init-all-event!

	toggle-callback: !->
		_reset!
		subItem.set-current-property-sub-item-dom-by-target {
			property-sub-item-list-dom 		: 	_property-sub-item-list-dom
		}

module.exports = new-manage
