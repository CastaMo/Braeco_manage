eventbus 				= require "../eventbus.js"
require_ 				= require "../requireManage.js"

[			getObjectURL, 				converImgTobase64] =
	[		util.getObjectURL, 		util.converImgTobase64]


class NewController
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@dc-type-map-dc-options = options.dc-type-map-dc-options
	
	init: !->
		@init-all-prepare!
		@init-all-event!

	init-all-prepare: !->
		@config-data 				= null
		@upload-pic-flag 		= null
		@pic 								= null

	init-all-event: !->

	reset: !->
		@upload-pic-flag 		= false
		@pic 								= null
		@config-data 				= 
			name 					: null
			name2 				: null
			type 					: null
			price 				: null
			groups			 	: []
			tag 					: null
			detail 				: null
			dc_type 			: null
			dc 						: null
		eventbus.emit "controller:new:reset"
		@add-subitem!

	pic-change: (file)!->
		@upload-pic-flag 	= true
		@pic 							= getObjectURL file

		eventbus.emit "controller:new:pic-change", @pic

	add-subitem: !->
		@config-data.groups.push {}
		eventbus.emit "controller:new:add-subitem"

	top-subitem: (index)!->
		if index <= 0 or index >= @groups.length then return alert "非法操作"
		subitem = @groups.splice index, 1
		@groups.unshift subitem
		eventbus.emit "controller:new:top-subitem", subitem, index

	remove-subitem: (index)!->
		if index < 0 or index >= @groups.length then return alert "非法操作"
		subitem = @groups.splice index, 1
		eventbus.emit "controller:new:remove-subitem" index

	set-config-data: (options)!->
		@config-data = options
		if @config-data.type isnt "combo_static" then @config-data.price = 0

	check-is-valid: !->

		is-ch-code = (num)->
			return num >= 0x4E00 and num <= 0x9FFF

		get-total-length-for-str = (str)->
			count = 0
			for i in [0 to str.length - 1]
				if is-ch-code str.char-code-at i then count += 2
				else count += 1
			return count
		console.log @config-data
		err-msg = ""; valid-flag = true
		if get-total-length-for-str(@config-data.name) <= 0 or get-total-length-for-str(@config-data.name) > 32 then err-msg += "套餐名称长度应为1~32位(一个中文字符占2个单位)\n"; valid-flag = false
		if get-total-length-for-str(@config-data.name2) > 32 then err-msg += "英文名长度应为0~32位(一个中文字符占2个单位)\n"; valid-flag = false
		if @config-data.type is "combo_static"
			if @config-data.price.length is 0 or Number(@config-data.price) < 0 or Number(@config-data.price) > 9999 then err-msg += "默认价格范围应为0~9999元\n"; valid-flag = false
		if get-total-length-for-str(@config-data.tag) > 18 then err-msg += "标签长度应为0~18位(一个中文字符占2个单位)\n"; valid-flag = false
		if get-total-length-for-str(@config-data.detail) > 400 then err-msg += "详情长度应为0~400位(一个中文字符占2个单位)\n"; valid-flag = false
		if @config-data.groups.length > 40 or @config-data.groups.length <= 0 then err-msg += "属性组数量应为1~40个\n"; valid-flag = false
		for elem, i in @config-data.require
			if 	elem.length is 0 or
					Number(elem) isnt parse-int(elem) or
					Number(elem) < 0 or
					Number(elem) > 999 then err-msg += "第#{i+1}项子项组中，任选个数的输入非法，应为非负整数0~999\n"; valid-flag = false
		if dc = @config-data.dc
			if options = @dc-type-map-dc-options[@config-data.dc-type]
				if Number(dc) < Number(options.min) or Number(dc) > Number(options.max) then err-msg += "优惠范围应在#{options.min}~#{options.max}之内\n"; valid-flag = false
		if not valid-flag then alert err-msg
		return valid-flag

	success-callback: (category-id)!->
		@config-data.able 					= true
		@config-data.default_price 	= @config-data.price
		@config-data.pic 						= @pic
		eventbus.emit "controller:new:add-combo", category-id, @config-data
		eventbus.emit "view:page:toggle-page", "main"
		@reset!

	require-for-new-combo: (category-id)!->
		if @upload-pic-flag
			callback = !~> @request-for-upload-pic !~> @success-callback category-id
		else callback = !~> @success-callback category-id
		eventbus.emit "view:page:cover-page", "loading"
		require_.get("add").require {
			data 			: 		{
				JSON 					:			JSON.stringify(@config-data)
				category-id 	: 		category-id
			}
			success 	: 		(result)!~> @config-data.id = result.id; callback!
			always 		:			!-> eventbus.emit "view:page:cover-page", "exit"
		}

	request-for-upload-pic: (callback)!->
		base64-str 	= ""
		data 				= {}

		check-is-already-and-upload = !~>
			if base64-str and data.token and data.key
				eventbus.emit "view:page:cover-page", "loading"
				require_.get("picUpload").require {
					data 			:		{
						fsize 	: 	-1
						token 	:		data.token
						key 		: 	btoa(data.key).replace("+", "-").replace("/", "_")
						url 		: 	base64-str
					}
					success 	:	 	(result)!~>
						@config-data.pic 		= "http://static.brae.co/#{data.key}"
						base64-str 					:= ""
						data 								:= {}
						console.log "success"
						callback?!
					always 		: 	!-> eventbus.emit "view:page:cover-page", "exit"
				}

		if @pic
			eventbus.emit "view:page:cover-page", "loading"
			require_.get("picUploadPre").require {
				data 		: 		{
					id 		: 		@config-data.id
				}
				success	:			(result)!->
					data.token 		= 		result.token
					data.key 			= 		result.key
					console.log "token ready"
					check-is-already-and-upload!
				always 	:			!-> eventbus.emit "view:page:cover-page", "exit"
			}

		if @pic then converImgTobase64 @pic, (data-URL)!->
			base64-str := data-URL.substr(data-URL.index-of(";base64,") + 8)
			console.log "base64 ready"
			check-is-already-and-upload!


module.exports = NewController