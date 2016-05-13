header = null
main-manage = let
	_state = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]

	_dishes = {}
	_dishes-array = {}
	_categories = {}
	_current-category-id = null
	_current-dish-id = []
	_is-all-choose = false

	_num-to-chinese = ["零","一","二","三","四","五","六","七","八","九","十"]

	_map-category-name-to-id 		= {}
	_food-single-select-dom 		= $ "select.food-single-select"
	_single-list-field-dom 			= $ ".single-list-field"
	_all-choose-field-dom 			= $ ".food-single-header-field .name-container > .t-choose"
	_all-choose-dom 				= _all-choose-field-dom.find ".choose-pic"

	_init-depend-module = !->
		header 		:= 		require "./headerManage.js"

	_init-all-food = (_get-food-JSON)!->
		all-foods = get-JSON _get-food-JSON!
		_fist-category = null
		for category, i in all-foods
			category_ = new Category {
				seqNum 		:		i
				name 		:		category.categoryname
				id 			:		category.categoryid
			}
			if i is 0 then _fist-category = category_
			for dish in category.dishes
				category_.add-dish dish
		_fist-category.select-self-event!

	_init-all-evnet = !->
		_food-single-select-dom.change !-> _categories[_map-category-name-to-id[@value]].select-self-event!
		_all-choose-field-dom.click _click-all-choose-event


	###
	#	header全选点击事件，由_is-all-choose这个标志变量决定。
	# 	如果_is-all-choose为true，则全部反选，否则全选
	###
	_click-all-choose-event = !->
		if _is-all-choose then _unchoose-current-all-dish!
		else _choose-current-all-dish!
			
	###
	# 	执行全选
	###
	_choose-current-all-dish = !->
		if not _current-category-id then return
		_is-all-choose := true; _all-choose-dom.add-class "choose"
		for dish in _dishes-array[_current-category-id]
			dish.choose-self!

	###
	# 	执行反选
	###
	_unchoose-current-all-dish = !->
		if not _current-category-id then return
		_is-all-choose := false; _all-choose-dom.remove-class "choose"
		for dish in _dishes-array[_current-category-id]
			dish.unchoose-self!


	###
	#	获取优惠信息相关的字符串
	#	@param 		{String} 	dcType 	: 优惠类型
	# 	@param 		{Number} 	dc 		: 优惠系数，根据类型不同而不同
	# 	@return 	{String} 	dcInfo 	: 优惠信息
 	###
	_get-dc-info = (dc-type, dc)->
		if dc-type is "discount"
			if dc % 10 is 0 then num = _num-to-chinese[Math.round dc/10]
			else num = dc / 10
			return "#{num}折"
		else if dc-type is "sale" then return "减#{dc}元"
		else if dc-type is "half" then return "第二份半价"
		else if dc-type is "limit" then return "剩#{dc}件"
		""

	###
	# 	将选中的餐品id添加至临时数组中, 并传递给header模块，用于更新header操作的可用性
	###
	_update-choose-dish = !->
		_current-dish-id := []
		for dish in _dishes-array[_current-category-id]
			if dish.is-choose then _current-dish-id.push dish.id
		header.check-all-control-headers-by-current-dish-id _current-dish-id

	class Category

		(options)!->
			deep-copy options, @
			_map-category-name-to-id[@name] = @id
			_categories[@id] = @
			_dishes[@id] = {}
			_dishes-array[@id] = []
			@init!

		_unshow-all-single-list = !->
			for id, category of _categories
				category.unshow-single-list-dom!

		init: !->
			@init-all-dom!
			@init-all-event!

		init-all-dom: !->
			@init-select-option-dom!
			@init-single-list-dom!

		init-all-event: !->

		init-select-option-dom: !->
			select-option-dom = $ "<option value='#{@name}'>#{@name}</option>"
			_food-single-select-dom.append select-option-dom

		###
		# 	prototype:
		#	生成餐品对应的容器list
		###
		init-single-list-dom: !->
			_get-single-list-dom = (category)->
				single-list-dom = $ "<ul class='single-list' id='single-list-#{category.seqNum}'></ul>"
				_single-list-field-dom.append single-list-dom
				single-list-dom.css {"display": "none"}
			@single-list-dom = _get-single-list-dom @

		show-single-list-dom: !-> @single-list-dom.fade-in 100

		unshow-single-list-dom: !-> @single-list-dom.fade-out 100

		add-dish: (options)!->
			dish = new Dish {
				able 			:		options.able 		|| false
				default-price 	:		options.defaultprice
				detail 			:		options.detail 		|| ""
				id 				:		options.dishid
				c-name 			:		options.dishname 	|| ""
				e-name 			:		options.dishname2 	|| ""
				pic 			:		options.dishpic 	|| ""
				groups 			:		options.groups 		|| []
				tag 			:		options.tag 		|| ""
				category-id 	:		@id
				dc-type			:		options.dc_type		|| ""
				dc 				:		options.dc 			|| 0
			}

		select-self-event: !->
			_unchoose-current-all-dish!
			_unshow-all-single-list!
			set-timeout (!~> @show-single-list-dom!), 100
			_current-category-id := @id

		class Dish
			(options)!->
				deep-copy options, @
				@init!
				_dishes[@category-id][@id] = @
				_dishes-array[@category-id].push @

			_get-single-content-dom = (dish)->
				dom = $ "<li class='single-content'>
							<div class='single-info'>
								<div class='t-choose'>
									<div class='choose-field'>
										<div class = 'choose-pic'></div>
									</div>
								</div>
								<div class='t-pic left-right-border'>
									<div class='pic-field'>
										<div class='pic default-square-image'></div>
									</div>
								</div>
								<div class='t-name'>
									<div class='name-field'>
										<p class='c-name'></p>
										<p class='e-name'></p>
									</div>
								</div>
								<div class='t-price left-right-border'>
									<div class='price-field'>
										<p></p>
									</div>
								</div>
								<div class='t-property'>
									<div class='property-field'></div>
								</div>
								<div class='t-dc left-right-border'>
									<div class='dc-field'></div>
								</div>
								<div class='t-remark'>
									<div class='remark-field'>
										<p></p>
									</div>
								</div>
								<div class='clear'></div>
							</div>
							<div class='single-cover'>
								<div class='hide-cover'>
									<p>售罄中</p>
								</div>
							</div>
						</li>"
				_categories[dish.category-id].single-list-dom.append dom
				dom

			init: !->
				@init-all-dom!
				@init-prepare!
				@init-all-event!

			init-all-dom: !->
				@init-single-content-dom!
				@init-detail-all-dom!
				@update-self-dom!

			init-prepare: !->
				@is-choose = false

			init-all-event: !->
				(@single-content-dom.find ".t-choose").click !~> @click-choose-event!

			init-single-content-dom: !->
				@single-content-dom = _get-single-content-dom @
					
			init-detail-all-dom: !->
				@choose-dom = @single-content-dom.find ".t-choose .choose-pic"
				@pic-dom = @single-content-dom.find ".t-pic .pic"
				@c-name-dom = @single-content-dom.find ".t-name p.c-name"
				@e-name-dom = @single-content-dom.find ".t-name p.e-name"
				@default-price-dom = @single-content-dom.find ".t-price p"
				@property-dom = @single-content-dom.find ".t-property .property-field"
				@dc-dom = @single-content-dom.find ".t-dc .dc-field"
				@remark-dom = @single-content-dom.find ".t-remark p"
				@cover-dom = @single-content-dom.find ".hide-cover"

			###
			# 	prototype
			#	根据自身的属性对dom作出变化
			###
			update-self-dom: !->
				_update-property-dom = (dish)!->
					dish.property-dom.html inner-html = ""
					len_ = (groups = dish.groups).length
					for i in [0 to 2]
						if not groups[i] then break
						inner-html += "<p>#{groups[i].groupname}</p>"
					if len_ > 3 then inner-html += "<p>余#{len_ - 3}项</p>"
					dish.property-dom.html inner-html

				_update-dc-dom = (dish)!->
					dish.dc-dom.html inner-html = ""
					inner-html = "<p>#{_get-dc-info dish.dc-type, dish.dc}</p>"
					dish.dc-dom.html inner-html

				if @pic then @pic-dom.css {"background-image":"url('#{@pic}')"} else @pic-dom.css {"background-image":""}
				if not @able then @cover-dom.fade-in 200
				@c-name-dom.html @c-name; @e-name-dom.html @e-name
				@default-price-dom.html @default-price
				_update-property-dom @
				_update-dc-dom @
				@remark-dom.html @tag

			click-choose-event: !-> if @is-choose then @unchoose-self! else @choose-self!

			choose-self: !-> @is-choose = true; @choose-dom.add-class "choose"; _update-choose-dish!

			unchoose-self: !-> @is-choose = false; @choose-dom.remove-class "choose"; _update-choose-dish!


	initial: (_get-food-JSON)!->
		_init-depend-module!
		_init-all-evnet!
		_init-all-food _get-food-JSON

	get-dish-by-id: (dish-id)->
		if _dishes[_current-category-id] then return _dishes[_current-category-id][dish-id]
		else return null

module.exports = main-manage