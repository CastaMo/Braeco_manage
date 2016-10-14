main = page = group = require_ = null
new-manange = let

	[		getObjectURL, 		deep-copy, 			getStrAfterFilter,
			converImgTobase64] =
		[	util.getObjectURL, 	util.deep-copy, 	util.getStrAfterFilter,
			util.converImgTobase64]

	_new-dom  				= $ "\#food-single-new"

	###
	# 	input有关的dom对象
	###
	_c-name-dom 			    = _new-dom.find "input\#c-name"
	_e-name-dom 			    = _new-dom.find "input\#e-name"
	_default-price-dom 		= _new-dom.find "input\#default-price"
	_pic-input-dom 			  = _new-dom.find "input\#new-pic"
	_remark-dom 			    = _new-dom.find "input\#remark-tag"
	_intro-dom 				    = _new-dom.find "textarea\#intro"
	_dc-type-select-dom 	= _new-dom.find "select\#select-dc-type"
	_dc-type-dom 			= _new-dom.find ".f-dc-field"
	_combo-only-dom 	    = _new-dom.find "select\#select-combo-only"

	_time-picker-dom 		= _new-dom.find "\#time-picker"

	_time-list-dom	 		= _new-dom.find "ul.time-list"

	###
	#	放置图片显示的dom
	###
	_pic-display-dom 		= _new-dom.find 'label .img'

	###
	#	放置属性组子项的dom
	###
	_property-sub-item-list-dom = _new-dom.find "ul.property-sub-item-list"

	###
	#	dc-type的额外dom，用于放置dc的input dom
	###
	_dc-field-dom 			= _new-dom.find ".addtional"

	###
	#	按钮dom
	###
	_property-add-dom = _new-dom.find ".add-btn"
	_cancel-dom 			= _new-dom.find ".cancel-btn"
	_save-dom 				= _new-dom.find ".save-btn"

	###
	#	当前对应的品类id
	###
	_current-category-id 	= null


	###
	#	属性变量
	###
	_new-id 				= 0
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
	_is-combo-only 			= null

	able_peroid_week 		= null
	able_peroid_day 		= null

	###
	#	所有dc-type的name
	###
	_all-dc-type-name = [
		"none", 		"sale", 		"discount",
		"half", 		"limit", 		"combo_only"
	]

	###
	#	dc-type对应的dc范围以及显示的字
	###
	_dc-type-map-dc-options = {
		"sale" 			: 			{
			min 		: 			1
			max 		:			100000
			word 		: 			"元"
		}
		"discount" 		:			{
			min 		:			10
			max 		:			99
			word 		:			"%"
		}
		"limit" 		:			{
			min 		:			1
			max 		:			100000
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
		_combo-only-dom.val "no"
		_combo-only-dom-change-event!

		_new-dom.find "ul.date-list li" .add-class "active"
		_time-list-dom.html _get-time-dom-str-by-value(0, 48)

		_c-name 				:= null
		_e-name 				:= null
		_default-price 			:= null
		_src 					:= null
		_remark 				:= null
		_intro 					:= null
		_dc-type 				:= null
		_dc 					:= null
		_groups 				:= []
		able_peroid_day 		:= null
		able_peroid_week 		:= null

		_upload-flag 			:= null

	_read-from-input = !->
		_get-dc-value = ->
			if _dc-type is "none" or _dc-type is "half" then return null
			return parse-int (_dc-field-dom.find "input").val!

		_get-week-value = ->
			value = 0
			_new-dom.find "ul.date-list li"
					.each (i, ele)!-> if $(ele).has-class "active" then value := value .|. (Math.pow(2, i))
			return value

		_get-day-value = ->
			temps = []
			value = 0
			map-num = {}
			_time-list-dom.find "li"
							.each (i, ele)!->
								start 	= $(ele).find "\#time-start" .data("value")
								end 	= $(ele).find "\#time-end" .data("value")
								temps.push [start, end]
			for temp in temps
				start 	= temp[0]
				end 	= temp[1]
				if start > end then value := -1; break
				if start is end then continue
				for i in [start to end - 1]
					if (map-num[i]) then continue
					map-num[i] = 1
					value += Math.pow(2, i)
			return value

		_c-name  			:= getStrAfterFilter _c-name-dom.val!
		_e-name 			:= getStrAfterFilter _e-name-dom.val!
		_default-price 		:= Number _default-price-dom.val!
		_remark 			:= getStrAfterFilter _remark-dom.val!
		_intro 				:= getStrAfterFilter _intro-dom.val!
		_dc-type 			:= getStrAfterFilter _dc-type-select-dom.val!
		_dc 				:= _get-dc-value!
		able_peroid_week 	:= _get-week-value!
		able_peroid_day 	:= _get-day-value!

	_connect-property-to-groups = !->
		group.set-current-property-sub-item-by-target {
			property-sub-item-list-dom 		: 		_property-sub-item-list-dom
			property-sub-item-array 		:		_groups
		}

	_check-is-valid = ->
		_valid-flag = true; _err-msg = ""

		is-ch-code = (num)->
			return num >= 0x4E00 and num <= 0x9FFF

		get-total-length-for-str = (str)->
			count = 0
			for i in [0 to str.length - 1]
				if is-ch-code str.char-code-at i then count += 2
				else count += 1
			return count


		if get-total-length-for-str(_c-name) <= 0 or get-total-length-for-str(_c-name) > 32 then _err-msg += "单品名称长度应为1~32位(一个中文字符占2个单位)\n"; _valid-flag = false
		if get-total-length-for-str(_e-name) > 32 then _err-msg += "英文名长度应为0~32位(一个中文字符占2个单位)\n"; _valid-flag = false
		if _default-price-dom.val! is "" or _default-price < 0 or _default-price > 9999 then _err-msg += "默认价格范围应为0~9999元\n"; _valid-flag = false
		if get-total-length-for-str(_remark) > 18 then _err-msg += "标签长度应为0~18位(一个中文字符占2个单位)\n"; _valid-flag = false
		if get-total-length-for-str(_intro) > 400 then _err-msg += "详情长度应为0~400位(一个中文字符占2个单位)\n"; _valid-flag = false
		if _groups.length > 40 then _err-msg += "属性组数量应为0~40个(一个中文字符占2个单位)\n"; _valid-flag = false
		if _dc
			options = _dc-type-map-dc-options[_dc-type]; if _dc < options.min or _dc > options.max then _err-msg += "优惠范围应在#{options.min}~#{options.max}之内\n"; _valid-flag = false
		if able_peroid_day is -1 then _err-msg += "对于上架时间的时间段，起点应小于终点\n"; _valid-flag = false
		if able_peroid_week is 0 then _err-msg += "上架日期不能为空\n"; _valid-flag = false
		if able_peroid_day is 0 then _err-msg += "上架时间不能为空\n"; _valid-flag = false
		if _valid-flag then return _valid-flag
		alert _err-msg; return _valid-flag

	_success-callback = !->
		main.create-dish-dish-by-given {
			able 				:		true
			default_price 		:		_default-price
			detail 				: 		_intro
			id 					:		_new-id
			name 				:		_c-name
			name2 				:		_e-name
			pic 				: 		_src
			groups 				: 		_groups
			tag 				:		_remark
			dc_type 			: 		_dc-type
			dc 					: 		_dc
			able_peroid_day 	: 		able_peroid_day
			able_peroid_week 	: 		able_peroid_week
		}

		page.toggle-page "main"
		_reset!

	_get-upload-JSON-for-add = ->
		if _is-combo-only then _dc-type := "combo_only"
		return JSON.stringify {
			dc_type 			:		_dc-type
			dc 					:		_dc
			price 				:		_default-price
			name 				:		_c-name
			name2 				:		_e-name
			tag 				:		_remark
			detail 				:		_intro
			groups 				:		_groups
			type 				:		"normal"
			able_peroid_day 	: 		able_peroid_day
			able_peroid_week 	: 		able_peroid_week
		}

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

	_combo-only-dom-change-event = !->
		_is-combo-only := _combo-only-dom.val! is "yes"
		if _is-combo-only then _dc-type-dom.fade-out 200
		else _dc-type-dom.fade-in 200

	###
	#	上传图片事件
	#	需要完成三个步骤
	#	①把将上传的图片转化为base64字符串
	#	②从服务器获取token与key
	#	③把图片(base64字符串)以及token一起上传给七牛服务器
	#	其中①和②可以并发进行(一个是调用Ajax异步API，一个是调用canvas同步API)，这里用到了信号量的思想去实现并发处理
	###
	_upload-pic-event = (callback)!->

		_base64-str = ""
		_data = {}


		_check-is-already-and-upload = !->
			if _base64-str and _data.token and _data.key
				#步骤③
				page.cover-page "loading"
				require_.get("picUpload").require {
					data 		:		{
						fsize 	:		-1
						token 	:		_data.token
						key 	:		btoa(_data.key).replace("+", "-").replace("/", "_")
						url 	:		_base64-str
					}
					success 	:		(result)->
						_src 		:= "http://static.brae.co/#{_data.key}"
						_base64-str := ""
						_data 		:= {}
						console.log "success"
						callback?!
					always 		:		!-> page.cover-page "exit"
				}

		#步骤②
		if _src
			page.cover-page "loading"
			require_.get("picUploadPre").require {
				data 		:		{
					id 		:		_new-id
				}
				success 	:		(result)->
					_data.token 	= 		result.token
					_data.key 		= 		result.key
					console.log "token ready"
					_check-is-already-and-upload!
				always 		:		!-> page.cover-page "exit"
			}

		#步骤①
		if _src then converImgTobase64 _src, (data-URL)->
			#图片base64字符串去除'data:image/png;base64,'后的字符串
			_base64-str := data-URL.substr(data-URL.index-of(";base64,") + 8)
			console.log "base64 ready"
			_check-is-already-and-upload!

	_cancel-btn-click-event = !->
		_reset!
		page.toggle-page "main"

	_save-btn-click-event = !->
		_read-from-input!
		if not _check-is-valid! then return
		if _upload-flag
			_callback = !-> _upload-pic-event !->
				_success-callback!
		else _callback = !-> _success-callback!
		page.cover-page "loading"
		require_.get("add").require {
			data 				:		{
				category-id 	:	_current-category-id
				JSON 			: 	_get-upload-JSON-for-add!
			}
			success 			: 	(result)!-> _new-id := result.id; _callback!
			always 				:	!-> page.cover-page "exit"
		}

	_get-time-array-by-value = (time-value)->
		hour-str = Math.floor(time-value / 2)
		if hour-str < 10 then hour-str = "0" + hour-str

		if time-value % 2 is 1 then minute-str = "30"
		else minute-str = "00"

		return [hour-str, minute-str]

	_set-time-value-for-time-picker = (time-value)!->
		time-array = _get-time-array-by-value time-value

		_time-picker-dom.find(".hour-picker p").html time-array[0]
		_time-picker-dom.find(".minute-picker p").html time-array[1]

		_time-picker-dom.data("value", time-value)

	_set-time-value-for-time-choose = (index, time-value)!->
		row-index = Math.floor(index / 2)
		col-index = index % 2
		time-array = _get-time-array-by-value time-value
		_time-list-dom
				.find("li:eq(#{row-index}) .time-choose:eq(#{col-index})")
				.html time-array.join(" : ")
				.data("value", time-value)

	_get-time-dom-str-by-value = (start-value, end-value)->
		start-time-array 	= _get-time-array-by-value start-value
		end-time-array 		= _get-time-array-by-value end-value
		return "<li class='time parallel-container'>
					<span id='time-start' class='time-choose' data-value='#{start-value}'>#{start-time-array.join(" : ")}</span>
					<span class='context-middle'>至</span>
					<span id='time-end' class='time-choose' data-value='#{end-value}'>#{end-time-array.join(" : ")}</span>
					<div class='delete-time-icon'></div>
					<div class='clear'></div>
				</li>"


	###************ event end **********###

	_init-all-event = !->

		_pic-input-dom.change !-> _pic-input-change-event @

		_dc-type-select-dom.change !-> _dc-type-select-change-event!

		_combo-only-dom.change !-> _combo-only-dom-change-event!

		_property-add-dom.click !-> _property-add-btn-click-event!

		_cancel-dom.click !-> _cancel-btn-click-event!

		_save-dom.click !-> _save-btn-click-event!

		$("body").click !->
			_time-picker-dom.fade-out 200

		_time-picker-dom.click !->
			return false

		_new-dom.on "click", ".time-choose", !->
			row-index = $(@).parents("li").index()
			if $(@).index() is 2 then col-index = 1
			else col-index = 0
			_time-picker-dom.css {
				"left" 	: "#{col-index * 140}px"
				"top" 	: "#{row-index * 50 + 50}px"
			}
			_time-picker-dom.data("index", row-index * 2 + col-index)

			time-value = $(@).data("value")

			_set-time-value-for-time-picker time-value

			_time-picker-dom.fade-in 200
			return false

		_time-picker-dom.on "click", ".confirm-btn", !->
			index = Number _time-picker-dom.data("index")
			time-value = Number _time-picker-dom.data("value")
			_set-time-value-for-time-choose index, time-value
			_time-picker-dom.fade-out 200

		_new-dom.on "click", ".add-time-btn" !->
			_time-list-dom.append $(_get-time-dom-str-by-value(0, 0))

		_time-list-dom.on "click", ".delete-time-icon", !->
			$(@).parents("li").remove()

		_new-dom.find(".date-list").on "click", "li", !->
			$(@).toggle-class "active"

		_time-picker-dom.on "click", ".upper-btn:eq(0)", !->
			time-value = _time-picker-dom.data("value")
			time-value = (time-value + 2) % 49
			_set-time-value-for-time-picker time-value

		_time-picker-dom.on "click", ".upper-btn:eq(1)", !->
			time-value = _time-picker-dom.data("value")
			time-value = (time-value + 1) % 49
			_set-time-value-for-time-picker time-value

		_time-picker-dom.on "click", ".down-btn:eq(0)", !->
			time-value = _time-picker-dom.data("value")
			time-value = (time-value + 47) % 49
			_set-time-value-for-time-picker time-value

		_time-picker-dom.on "click", ".down-btn:eq(1)", !->
			time-value = _time-picker-dom.data("value")
			time-value = (time-value + 48) % 49
			_set-time-value-for-time-picker time-value

	_init-depend-module = !->
		main  		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"
		group 		:= require "./groupManage.js"
		require_ 	:= require "./requireManage.js"


	initial: !->
		_reset!
		_init-all-event!
		_init-depend-module!

	toggle-callback: (current-category-id)!->
		_reset!
		_current-category-id 	:= current-category-id
		_groups 				:= []
		_connect-property-to-groups!



module.exports = new-manange
