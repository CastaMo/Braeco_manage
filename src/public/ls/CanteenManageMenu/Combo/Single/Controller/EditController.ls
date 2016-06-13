eventbus 				= require "../eventbus.js"
require_ 				= require "../requireManage.js"

[			getObjectURL, 			converImgTobase64] =
	[		util.getObjectURL, 	util.converImgTobase64]

class EditController
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
		@id 								= null

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
		eventbus.emit "controller:edit:reset"

	pic-change: (file)!->
		@upload-pic-flag 	= true
		@pic 							= getObjectURL file
		eventbus.emit "controller:edit:pic-change", @pic

	add-subitem: !->
		@config-data.groups.push {}
		eventbus.emit "controller:edit:add-subitem"

	top-subitem: (index)!->
		if index <= 0 or index >= @groups.length then return alert "非法操作"
		subitem = @groups.splice index, 1
		@groups.unshift subitem
		eventbus.emit "controller:edit:top-subitem", subitem, index

	remove-subitem: (index)!->
		if index < 0 or index >= @groups.length then return alert "非法操作"
		subitem = @groups.splice index, 1
		eventbus.emit "controller:edit:remove-subitem" index

	set-config-data: (options)!->
		@config-data = options
		if @config-data.type isnt "combo_sum" then @config-data.price = 0

	check-is-valid: !->
		err-msg = ""; valid-flag = true
		if @config-data.name.length <= 0 or @config-data.name.length > 32 then err-msg += "套餐名称长度应为1~32位\n"; valid-flag = false
		if @config-data.name2.length > 32 then err-msg += "英文名长度应为0~32位\n"; valid-flag = false
		if @config-data.type is "combo_sum"
			if @config-data.price.length is 0 or Number(@config-data.price) < 0 or Number(@config-data.price) > 9999 then err-msg += "默认价格范围应为0~9999元\n"; valid-flag = false
		if @config-data.tag.length > 18 then err-msg += "标签长度应为0~18位\n"; valid-flag = false
		if @config-data.detail.length > 400 then err-msg += "详情长度应为0~400位\n"; valid-flag = false
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
		eventbus.emit "controller:edit:edit-combo", category-id, @id, @config-data
		eventbus.emit "view:page:toggle-page", "main"
		@reset!

	require-for-edit-combo: (category-id)!->
		if @upload-pic-flag
			callback = !~> @request-for-upload-pic !~> @success-callback category-id
		else callback = !~> @success-callback category-id
		require_.get("edit").require {
			data 			: 		{
				JSON 					:			JSON.stringify(@config-data)
				dish-id 			: 		@id
			}
			success 	: 		(result)!~> callback!
		}

	request-for-upload-pic: (callback)!->
		base64-str 	= ""
		data 				= {}

		check-is-already-and-upload = !~>
			if base64-str and data.token and data.key
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
				}

		if @pic
			require_.get("picUploadPre").require {
				data 		: 		{
					id 		: 		@id
				}
				success	:			(result)!->
					data.token 		= 		result.token
					data.key 			= 		result.key
					console.log "token ready"
					check-is-already-and-upload!
			}

		if @pic then converImgTobase64 @pic, (data-URL)!->
			base64-str := data-URL.substr(data-URL.index-of(";base64,") + 8)
			console.log "base64 ready"
			check-is-already-and-upload!

	read-from-combo: (combo)!->
		@id 				= combo.id
		@pic 				= combo.pic
		eventbus.emit "controller:edit:pic-change", @pic
		eventbus.emit "controller:edit:read-from-combo", combo

module.exports = EditController