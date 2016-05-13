main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = null
	value = []
	dayAry = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
	day = ''
	time = ''
	pay = ''
	payAry = ["现金支付", "支付宝", "微信支付", "百度钱包"]
	number = ''
	
	_modifyForBus-dom = $ "\#modifyForBus"
	_add-dom = $ "\.modifyAddTime"
	_del-dom = $ "\.modifyDelTime"
	_cancel-dom = $ "\.canBtn"
	_finish-dom = $ "\.finBtn"

	_init-all-event = !->
		document.getElementById("showDay").innerHTML = '周一 周二 周三 周四 周五 周六 周日'
		document.getElementById("showPay").innerHTML = '现金支付 支付宝 微信支付 百度钱包'
		document.getElementById("showTime").innerHTML = '00:00 ~ 23:59'
		_modifyForBus-dom.click !->
			page.toggle-page "mod"
		_finish-dom.click !->
			_save-form-value!
			_show-form-value!
			page.toggle-page "pre"
		_cancel-dom.click !->
			page.toggle-page "pre"
		_add-dom.click !->
			document.getElementById("timer").createElement = ("timer")
		_del-dom.click !->


	_show-form-value = ->
		x = document.getElementById("myForm")
		pay = ''
		day = ''
		time = ''
		for i from 0 to 6 by 1
			if value[i] == 1
				day += dayAry[i] + '  '
		document.getElementById("showDay").innerHTML = day
		for i from 7 to x.length-6 by 1
			if i%2 == 1
				time += value[i] + ' ~ '
			else if i%2 == 0
				time += value[i] + '  '
		document.getElementById("showTime").innerHTML = time
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
		for i from 7 to x.length-6 by 1
			value[i] = x.elements[i].value
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
