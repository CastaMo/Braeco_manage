main-manage = let
	page = require_ = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	window["_ladder"] = []
	charge_ladder = []
	cashEXP = ""
	_ladder = {}
	_level-modify-btn-dom = $ "\#level-modify-btn"
	_recharge-modify-btn-dom = $ "\#recharge-modify-btn"
	_cancel-btn-dom = $ "\.canBtn"
	_charge-finish-btn-dom = $ "\.charge-finBtn"
	_level-finish-btn-dom = $ "\.level-finBtn"

	_init-table = (_get-JSON)!->
		all = get-JSON _get-JSON!
		_ladder = all['ladder']
		charge_ladder = all['charge_ladder']
		cashEXP = all['cashEXP']
		$("._tip-1").html("顾客每消费1元获得 #{cashEXP} 积分")
		for i from 0 to 5 by 1
			$("\#level-table tr").eq(i+1).children("td").eq(0).html("LV#{i}.#{_ladder[i].name}")
			$("\#level-table tr").eq(i+1).children("td").eq(1).html("#{_ladder[i].EXP}")
			$("\#level-table tr").eq(i+1).children("td").eq(2).html("#{_ladder[i].discount}% (#{_ladder[i].discount/10}折)")
			$("._lv#{i}-upgrade").val(_ladder[i].EXP)
			$("._lv#{i}-discout").val(_ladder[i].discount)
		for j from 0 to 4 by 1
			$("\#recharge-table tr").eq(j+1).children("td").eq(0).html("#{j+1}")
			$("\#recharge-table tr").eq(j+1).children("td").eq(1).html("#{charge_ladder[j].pay}元")
			$("\#recharge-table tr").eq(j+1).children("td").eq(2).html("#{charge_ladder[j].get}元")
			$("\#recharge-table tr").eq(j+1).children("td").eq(3).html("#{charge_ladder[j].EXP}")
			$("._re#{j+1}").val(charge_ladder[j].pay)
			$("._re#{j+1}-real").val(charge_ladder[j].get)
			$("._gitf#{j+1}-input").val(charge_ladder[j].EXP)
		$("._tip-1-input").val(cashEXP)
	_init-all-event = !->
		_level-modify-btn-dom.click !->
			page.toggle-page "modify-level"

		_recharge-modify-btn-dom.click !->
			page.toggle-page "modify-recharge"

		_cancel-btn-dom.click !->
			page.toggle-page "basic"

		_level-finish-btn-dom.click !->
			isValid = !->
				for i from 0 to 12 by 1
					_check = $('#modify-level input').val!
					if _check.length > 0 && /^[0-9]+$/.test(_check)
						return true
					else
						return false
			_ladder = []
			request-object = {}
			cashEXP = Number($("._tip-1-input").val!)
			_ladder.push({"name":"\u9ed1\u94c1","EXP":0,"discount":100})
			for i from 1 to 5 by 1
				_object = {}
				_object.name = $("\#level-table tr").eq(i+1).children("td").eq(0).html!
				_object.name = _object.name.substr(4, 30)
				_object.EXP =  Number($("._lv#{i}-upgrade").val!)
				_object.discount = Number($("._lv#{i}-discout").val!)
				_ladder.push(_object)
			_vaild = 0
			for i from 1 to 5 by 1
				if _ladder[i].discount <= _ladder[i-1].discount and _ladder[i].EXP >= _ladder[i-1].EXP
					_vaild++
			console.log "_vaild", _vaild
			if _vaild is 5 then
				request-object.ladder = _ladder
				request-object.cashEXP = cashEXP
				console.log "request-object", request-object
				require_.get("Ladder").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
					}
					success 	:		(result)!-> location.reload!
				}
				location.href = "/Manage/Market/Member/Setting"
			else alert("后一项升级积分必须大于等于前一项，后一项折扣必须小于等于前一项")

		_charge-finish-btn-dom.click !->
			request-object = []
			for j from 0 to 4 by 1
				_object = {}
				_object.pay = Number($("._re#{j+1}").val!)
				_object.get = Number($("._re#{j+1}-real").val!)
				_object.EXP = Number($("._gitf#{j+1}-input").val!)
				request-object.push(_object)
			require_.get("Charge").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				success 	:		(result)!-> location.reload!
			}

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"


	initial: (_get-JSON)!->
		_init-table _get-JSON
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage