main = page = null
new-manange = let

	[		getObjectURL] = 
		[	util.getObjectURL]

	_new-dom  				= $ "\#food-single-new"

	###
	# 	input有关的dom对象
	###
	_c-name-dom 			= _new-dom.find "input\#c-name"
	_e-name-dom 			= _new-dom.find "input\#e-name"
	_default-price-dom 		= _new-dom.find "input\#default-price"
	_pic-input-dom 			= _new-dom.find "input\#new-pic"
	_remark-dom 			= _new-dom.find "input\#remark-tag"
	_intro-dom 				= _new-dom.find "textarea\#intro"
	_dc-type-select-dom 	= _new-dom.find "select\#select-dc-type"

	###
	#	放置图片显示的dom
	###
	_pic-display-dom 		= _new-dom.find 'label .img'

	###
	#	dc-type的额外dom，用于放置dc的input dom
	###
	_dc-field-dom 			= _new-dom.find ".addtional"

	###
	#	按钮dom
	###
	_cancel-dom 			= _new-dom.find ".cancel-btn"
	_save-dom 				= _new-dom.find ".save-btn"


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

	_read-from-input = !->
		_get-dc-value = ->
			if _dc-type is "none" or _dc-type is "half" then return null
			return parse-int (_dc-field-dom.find "input").val!

		_c-name  			:= _c-name-dom.val!
		_e-name 			:= _e-name-dom.val!
		_default-price 		:= parse-int _default-price-dom.val!
		_remark 			:= _remark-dom.val!
		_intro 				:= _intro-dom.val!
		_dc-type 			:= _dc-type-select-dom.val!
		_dc 				:= _get-dc-value!

	###************ operation end **********###




	###************ event start **********###

	_cancel-btn-click-event = !->
		_reset!
		page.toggle-page "main"

	_save-btn-click-event = !->
		_reset!
		page.toggle-page "main"

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


	###************ event end **********###

	_init-all-event = !->

		_pic-input-dom.change !-> _pic-input-change-event @

		_dc-type-select-dom.change !-> _dc-type-select-change-event!

		_cancel-dom.click !-> _cancel-btn-click-event!

		_save-dom.click !-> _save-btn-click-event!


	_init-depend-module = !->
		main  	:= require "./mainManage.js"
		page 	:= require "./pageManage.js"


	initial: !->
		_reset!
		_init-all-event!
		_init-depend-module!



module.exports = new-manange