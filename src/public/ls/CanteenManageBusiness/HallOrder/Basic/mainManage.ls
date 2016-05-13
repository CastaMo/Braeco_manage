main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = null
	value = []
	dayAry = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
	day = ''
	time = null
	pay = ''
	payAry = ["现金支付", "支付宝", "微信支付", "百度钱包"]
	count = null
	
	_modifyForBus-dom = $ "\#modifyForBus"
	_cancel-dom = $ "\.canBtn"
	_finish-dom = $ "\.finBtn"

	_init-all-event = !->
		document.getElementById("showDay").innerHTML = '周一 周二 周三 周四 周五 周六 周日'
		document.getElementById("showPay").innerHTML = '现金支付 支付宝 微信支付 百度钱包'
		_modifyForBus-dom.click !->
			page.toggle-page "mod"
		_finish-dom.click !->
			_save-form-value!
			_show-form-value!
			page.toggle-page "pre"
		_cancel-dom.click !->
			page.toggle-page "pre"

	_show-form-value = ->
		x = document.getElementById("myForm")
		pay = ''
		day = ''
		for i from 0 to 6 by 1
			if value[i] == 1
				day += dayAry[i] + '  '
		document.getElementById("showDay").innerHTML = day
		for i from x.length-5 to x.length-1 by 1
			if value[i] == 1
				pay += payAry[i-9] + '  '
				value[i] = 1
		document.getElementById("showPay").innerHTML = pay

	_save-form-value = ->
		x = document.getElementById("myForm")
		for i from 0 to 6 by 1
			if x.elements[i].checked == true
				value[i] = 1
			else value[i] = 0
		for i from x.length-5 to x.length-1 by 1
			if x.elements[i].checked == true
				value[i] = 1
			else value[i] = 0

	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_show-form-value!
		_init-depend-module!
		_init-all-event!

module.exports = main-manage
