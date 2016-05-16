main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = null
	value = []
	dayAry = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
	day = ''
	time = ''
	pay = ''
	test = 0
	payAry = ["现金支付", "支付宝", "微信支付", "百度钱包"]
	can = ''
	
	_modifyForBus-dom = $ "\#modifyForBus"
	_add-dom = $ "\.modifyAddTime"
	_del-dom = $ "\.modifyDelTime"
	_timerAll-dom = $"\#timerAll"
	_cancel-dom = $ "\.canBtn"
	_finish-dom = $ "\.finBtn"
	_select-dom = $ "\#selectBusiness"

	_init-all-event = !->
		document.getElementById("showDay").innerHTML = '周一 周二 周三 周四 周五 周六 周日'
		document.getElementById("showPay").innerHTML = '现金支付 支付宝 微信支付 百度钱包'
		document.getElementById("showTime").innerHTML = '00:00~23:59'
		document.getElementById("showCan").innerHTML = '全选'
		_modifyForBus-dom.click !->
			page.toggle-page "mod"
		_finish-dom.click !->
			_save-form-value!
			_show-form-value!
			page.toggle-page "pre"
		_cancel-dom.click !->
			page.toggle-page "pre"
		_add-dom.click !->
			faNode = document.getElementById("timerAll")
			lastNode = faNode.lastChild
			newLastNode = lastNode.cloneNode(true)
			faNode.appendChild(newLastNode)
			$("\.modifyDelTime").click !->
				delNode = @parentNode
				faNode.removeChild(delNode)
		_del-dom.click !->
			faNode = document.getElementById("timerAll")
			delNode = @parentNode
			faNode.removeChild(delNode)
		_select-dom.change !->
			selectValue = $("input[name='select']:checked").val()
			if selectValue == "run"
				document.getElementById("previewBusiness").style.color = "#333333"
				document.getElementById("previewBusiness").style.border-color = "#333333"				
			else if selectValue == "stop"
				document.getElementById("previewBusiness").style.color = "#797979"
				document.getElementById("previewBusiness").style.border-color = "#797979"
	_show-form-value = ->
		x = document.getElementById("myForm")
		pay = ''
		day = ''
		time = ''
		can = ''
		count = 0
		test = 0
		for i from 0 to 6 by 1
			if value[i] == 1
				day += dayAry[i] + '&nbsp&nbsp'
		document.getElementById("showDay").innerHTML = day
		for i from 7 to x.length-6 by 1
			if i%2 == 1
				if value[i] == '' || value[i+1] == ''
					time += ''
				else time += value[i] + '~'
			else if i%2 == 0
				if value[i] == '' || value[i-1] == ''
					time += ''
				else time += value[i] + '&nbsp&nbsp&nbsp'
		document.getElementById("showTime").innerHTML = time
		for i from x.length-5 to x.length-2 by 1
			if value[i] == 1
				test = i-(x.length-5)
				pay += payAry[test] + '&nbsp&nbsp'
				value[i] = 1
		document.getElementById("showPay").innerHTML = pay
		selNum = $ "\#selNum"
		can = selNum.find("option:selected").text()
		document.getElementById("showCan").innerHTML = can

	_save-form-value = ->
		x = document.getElementById("myForm")
		for i from 0 to 6 by 1
			if x.elements[i].checked == true
				value[i] = 1
			else value[i] = 0
		for i from 7 to x.length-6 by 1
			value[i] = x.elements[i].value
		for i from x.length-5 to x.length-2 by 1
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
