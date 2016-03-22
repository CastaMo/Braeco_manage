require-manage = let
	_instance = null

	class RequireManage
		_allRequireName = ['login', 'bookOrder', 'recharge', 'getId', 'like', 'getAllData']
		_allRequireUrl = ['/Eater/Login/Mobile', '/Order/Add', '/Membership/Card/Charge', '/server/captcha', '/Eater/Like/Dinner/', '/Table/Home']

		_requires = {}

		_notNeedPingMoneyPaid = ['cash', 'prepayment', 'alipay_qr_f2f']

		_needPingMoneyPaid = ['wx_pub', 'alipay_wap', 'bfb_wap']

		_defaultConfig = {
			async 	:	true
			type 	:	"POST"
		}

		_loginFailCallBack = {
			"Already login"					:	-> hashRoute.back()
			"Captcha needed"				:	-> alert("需要验证码")
			"Captcha not generated"			:	-> alert("尚未生成验证码")
			"Captcha expired"				:	-> alert("验证码过期")
			"Wrong captcha"					:	-> alert("验证码错误")
			"This mobile has binded weixin" :	-> alert("该手机号已绑定其他微信账号")
			"Need to rescan qrcode"			:	-> window.location.pathname = "/Table/Confirm/rescan"
		}

		_bookFailCallBack = {
			"The money given does not match database" 		:	-> alert("餐厅已更新了价格，请刷新后重新下单")
			"Dinner not online" 							:	-> alert("下单失败, 餐厅端未开启,\n请联系服务员反馈情况")
			"Order too large"								:	-> alert("订单过长")
			"Need to rescan qrcode"							:	-> window.location.pathname = "/Table/Confirm/rescan"
			"Some dish is beyond limit"						:	(arr)-> bookOrder.deleteDisabledDishes arr, "limit"
			"Dish disabled"									:	(arr)-> bookOrder.deleteDisabledDishes arr, "disabled"
		}

		_getIdFailCallBack = {
			"Invalid phone number"			:	-> alert("手机号码非法")
			"Need to rescan qrcode"			:	-> window.location.pathname = "/Table/Confirm/rescan"
			"Captcha needed"				:	-> user.isNeedPicIdChange true
			"Captcha not generated"			:	-> alert "验证码尚未生成"
			"Captcha expired"				:	-> alert "验证码过期"
			"Wrong captcha"					:	-> alert "验证码错误"
		}

		_likeFailCallBack = {
			"Need to rescan qrcode"			:	-> window.location.pathname = "/Table/Confirm/rescan"
		}

		_getAllDataFailCallback = {
			"Need to rescan qrcode"			:	-> window.location.pathname = "/Table/Confirm/rescan"
		}

		_getGeneralFunc = (name, options)->
			if name is "login"
				return (id, callback, always)->
					ajax({
						data 	:	"captcha=#{id}"
						url 	: 	options.url
						type 	:	options.type
						async 	:	options.async
						success :	(result_)->
							result = getJSON result_
							message = result.message
							if message is "success" then callback?(result)
							else if message then _loginFailCallBack[message]?()
							else alert("系统错误")
						always 	:	always
					})

			else if name is "bookOrder"
				return (contents, moneyPaid, callback, always, memo)->
					memoStr = ""
					if memo then memoStr = "&describtion=#{memo}"
					ajax({
						data 	:	"contents=#{contents}&moneypaid=#{moneyPaid}#{memoStr}"
						url 	: 	options.url
						type 	:	options.type
						async 	:	options.async
						success :	(result_)->
							result = getJSON result_
							message = result.message
							if message is "success"
								locStor.set("orderId", result.id)
								if moneyPaid in _notNeedPingMoneyPaid then callback?()
								else if moneyPaid in _needPingMoneyPaid
									charge = result["pingxx"]
									pingpp.createPayment(charge, (result, error)->
										if result is "success" then callback?()
									)
								else if moneyPaid is "p2p_wx_pub"
									callpay {
										appid: result.appid
										timestamp: result.timestamp
										noncestr: result.noncestr
										signature: result.signature
										package: result.package
										signMD: result.signMD
										callback: callback
									}
							else if message then _bookFailCallBack[message]?(result.dishes)
							else alert("系统错误")
						always 	:	always
					})
			else if name is "recharge"
				return (amount, channel, callback, always)->
					ajax({
						data 	:	"amount=#{amount}&channel=#{channel}"
						url 	: 	options.url
						type 	:	options.type
						async 	:	options.async
						success :	(result_)->
							result = getJSON result_
							message = result.message
							if message is "success"
								if channel in _notNeedPingMoneyPaid then callback?()
								else if channel in _needPingMoneyPaid
									charge = result["pingxx"]
									pingpp.createPayment(charge, (result, error)->
										if result is "success" then callback?()
									)
								else if channel is "p2p_wx_pub"
									callpay {
										appid: result.appid
										timestamp: result.timestamp
										noncestr: result.noncestr
										signature: result.signature
										package: result.package
										signMD: result.signMD
										callback: callback
									}
							else if message then _bookFailCallBack[message]?()
							else alert("系统错误")
						always 	:	always
					})
			else if name is "getId"
				return (mobile, callback, always, picId)->
					ajax({
						data 	:	"type=testmsg&mobile=#{mobile}&captcha=#{picId}"
						url 	:	options.url
						type 	:	options.type
						async	:	options.async
						success :	(result_)->
							result = getJSON result_
							message = result.message
							if message is "success" then callback?(result)
							else if message then _getIdFailCallBack[message]?()
							else alert("系统错误")
						always 	:	always
					})
			else if name is "like"
				return (x, callback, always)->
					ajax({
						url 	:	"#{options.url}#{x}"
						type 	:	options.type
						async	:	options.async
						success :	(result_)->
							result = getJSON result_
							message = result.message
							if message is "success" then callback?()
							else if message then _likeFailCallBack[message]?()
							else alert("系统错误")
						always 	:	always
					})
			else if name is "getAllData"
				return (callback, fail, always)->
					ajax({
						url 	:	options.url
						type 	:	options.type
						async 	:	options.async
						success :	(result_)->
							result = getJSON result_
							message = result.message
							if message is "success" then callback?(result)
							else if message then _getAllDataFailCallback[message]?()
							else fail?()
						always :	always
					})
			else return -> alert("呵呵")


		class Require

			constructor: (options)->
				deepCopy options, @
				@init()
				_requires[@name] = @

			init: ->
				@initRequire()

			initRequire: ->
				requireObj = {}
				deepCopy _defaultConfig, requireObj
				requireObj.url = @url
				@require = _getGeneralFunc @name, requireObj

				



		constructor: ->
			for name, i in _allRequireName
				require = new  Require {
					name 		:		name
					url 		:		_allRequireUrl[i]
				}
		get: (name)-> return _requires[name]

	getInstance: ->
		if _instance is null then _instance = new RequireManage()
		return _instance

	initial: ->
		requireManage = RequireManageSingleton.getInstance()

module.exports = require-manage
