main = page = group = null
edit-manange = let

	[		getObjectURL, 		deep-copy, 			getStrAfterFilter] = 
		[	util.getObjectURL, 	util.deep-copy, 	util.getStrAfterFilter]

	_edit-dom  				= $ "\#food-single-edit"

	###
	# 	input有关的dom对象
	###
	_c-name-dom 			= _edit-dom.find "input\#c-name"
	_e-name-dom 			= _edit-dom.find "input\#e-name"
	_default-price-dom 		= _edit-dom.find "input\#default-price"
	_pic-input-dom 			= _edit-dom.find "input\#edit-pic"
	_remark-dom 			= _edit-dom.find "input\#remark-tag"
	_intro-dom 				= _edit-dom.find "textarea\#intro"
	_dc-type-select-dom 	= _edit-dom.find "select\#select-dc-type"

	###
	#	放置图片显示的dom
	###
	_pic-display-dom 		= _edit-dom.find 'label .img'

	###
	#	放置属性组子项的dom
	###
	_property-sub-item-list-dom = _edit-dom.find "ul.property-sub-item-list"

	###
	#	dc-type的额外dom，用于放置dc的input dom
	###
	_dc-field-dom 			= _edit-dom.find ".addtional"

	###
	#	按钮dom
	###
	_property-add-dom 		= _edit-dom.find ".add-btn"
	_cancel-dom 			= _edit-dom.find ".cancel-btn"
	_save-dom 				= _edit-dom.find ".save-btn"


	###
	#	当前编辑的dish
	###
	_current-dish  			= null
	_current-category-id 	= null

	###
	#	属性变量
	###
	_c-name 				= null
	_e-name 				= null
	_default-price 			= null
	_src 					= null
	_remark 				= null
	_intro 					= null
	_dc-type 				= null
	_dc 					= null
	_groups 				= null
	_upload-flag 			= null

	###
	#	所有dc-type的name
	###
	_all-dc-type-name = [
		"none", 		"sale", 		"discount",
		"half", 		"limit"
	]

	###
	#	dc-type对应的dc范围以及显示的字
	###
	_dc-type-map-dc-options = {
		"sale" 			: 			{
			min 		: 			1
			max 		:			50
			word 		: 			"元"
		}
		"discount" 		:			{
			min 		:			10
			max 		:			99
			word 		:			"%"
		}
		"limit" 		:			{
			min 		:			1
			max 		:			99
			word 		:			"份"
		}
	}

	###************ operation start **********###

	_reset = !->
		_c-name-dom.val null
		_e-name-dom.val null
		_default-price-dom.val null
		_pic-input-dom.val null
		_remark-dom.val null
		_intro-dom.val null
		_dc-type-select-dom.val "无"; _dc-type-select-change-event!
		_pic-display-dom.css {"background-image" : ""}

		_c-name 				:= null
		_e-name 				:= null
		_default-price 			:= null
		_src 					:= null
		_remark 				:= null
		_intro 					:= null
		_dc-type 				:= null
		_dc 					:= null
		_upload-flag 			:= null
		_groups 				:= []

		_current-dish 			:= null

	_read-from-input = !->
		_get-dc-value = ->
			if _dc-type is "none" or _dc-type is "half" then return null
			return parse-int (_dc-field-dom.find "input").val!

		_c-name  			:= getStrAfterFilter _c-name-dom.val!
		_e-name 			:= getStrAfterFilter _e-name-dom.val!
		_default-price 		:= parse-int _default-price-dom.val!
		_remark 			:= getStrAfterFilter _remark-dom.val!
		_intro 				:= getStrAfterFilter _intro-dom.val!
		_dc-type 			:= getStrAfterFilter _dc-type-select-dom.val!
		_dc 				:= _get-dc-value!

	_connect-property-to-groups = !->
		group.set-current-property-sub-item-by-target {
			property-sub-item-list-dom 		: 		_property-sub-item-list-dom
			property-sub-item-array 		:		_groups
		}

	_read-from-current-dish = !->

		_c-name-dom.val _current-dish.c-name
		_e-name-dom.val _current-dish.e-name
		_default-price-dom.val _current-dish.default-price
		_remark-dom.val _current-dish.tag
		_intro-dom.val _current-dish.detail
		_dc-type-select-dom.val _current-dish.dc-type
		_dc-type-select-change-event!
		if _current-dish.dc then (_dc-field-dom.find "input").val _current-dish.dc

		_src 					:= _current-dish.pic
		if _src then _pic-display-dom.css {"background-image" : "url('#{_src}')"}

		###
		#	连接当前属性组与当前餐品以及groupMange进行绑定
		###
		_groups 				:= []
		deep-copy _current-dish.groups, _groups
		_connect-property-to-groups!		

		_upload-flag 			:= null

		_read-from-input!


	_check-is-valid = ->
		_read-from-input!
		_valid-flag = true; _err-str = ""
		if _c-name.length <= 0 or _c-name.length > 32 then _err-str += "单品名称长度应为1~32位\n"; _valid-flag = false
		if _e-name.length > 32 then _err-str += "英文名长度应为0~32位\n"; _valid-flag = false
		if _default-price-dom.val! is "" or _default-price < 0 or _default-price > 9999 then _err-str += "默认价格范围应为0~9999元\n"; _valid-flag = false
		if _remark.length > 18 then _err-str += "标签长度应为0~18位\n"; _valid-flag = false
		if _intro.length > 400 then _err-str += "详情长度应为0~400位\n"; _valid-flag = false
		if _groups.length > 40 then _err-str += "属性组数量应为0~40个\n"; _valid-flag = false
		if _dc
			options = _dc-type-map-dc-options[_dc-type]; if _dc < options.min or _dc > options.max then _err-str += "优惠范围应在#{options.min}~#{options.max}之内\n"; _valid-flag = false
		if _valid-flag then return _valid-flag
		alert _err-str; return _valid-flag

	_success-callback = !->
		main.edit-for-current-choose-dish-by-given _current-dish.id, {
			default-price 		:		_default-price
			detail 				: 		_intro
			c-name 				:		_c-name
			e-name 				:		_e-name
			pic 				: 		_src
			groups 				: 		_groups
			tag 				:		_remark
			dc-type 			: 		_dc-type
			dc 					: 		_dc
		}
		page.toggle-page "main"
		_reset!

	###************ operation end **********###




	###************ event start **********###

	_pic-input-change-event = (input)!->
		if file = input.files[0]
			if ((fsize = parse-int(file.size)) / 1024).to-fixed(2) > 4097 then alert "图片大小不能超过4M"
			else
				_upload-flag := true
				_src := getObjectURL file
				_pic-display-dom.css {"background-image":"url(#{_src})"}

	_dc-type-select-change-event = !->
		_dc-type := _dc-type-select-dom.val!
		_dc-field-dom.html ""
		if options = _dc-type-map-dc-options[_dc-type]
			_dc-field-dom.html "<input type='number' placeholder='(#{options.min}-#{options.max})' max='#{options.max}' min='#{options.min}'>
								<p>#{options.word}</p>
								<div class='clear'></div>"

	_property-add-btn-click-event = !-> page.cover-page "property"; group.set-current-property-active!

	_cancel-btn-click-event = !->
		_reset!
		page.toggle-page "main"

	_save-btn-click-event = !->
		if _check-is-valid! then _success-callback!


	###************ event end **********###

	_init-all-event = !->

		_pic-input-dom.change !-> _pic-input-change-event @

		_dc-type-select-dom.change !-> _dc-type-select-change-event!

		_property-add-dom.click !-> _property-add-btn-click-event!

		_cancel-dom.click !-> _cancel-btn-click-event!

		_save-dom.click !-> _save-btn-click-event!


	_init-depend-module = !->
		main  	:= require "./mainManage.js"
		page 	:= require "./pageManage.js"
		group 	:= require "./groupManage.js"


	initial: !->
		_reset!
		_init-all-event!
		_init-depend-module!

	toggle-callback: (dish, current-category-id)!->
		_current-dish := dish;
		_read-from-current-dish!



module.exports = edit-manange