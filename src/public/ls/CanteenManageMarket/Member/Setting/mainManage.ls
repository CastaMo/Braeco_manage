main-manage = let
	page = require_ = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	charge_ladder = []
	cashEXP = ""
	_ladder = {}
	_level-modify-btn-dom = $ "\#level-modify-btn"
	_recharge-modify-btn-dom = $ "\#recharge-modify-btn"
	_charge-cancel-btn-dom = $ "\#modify-recharge .canBtn"
	_level-cancel-btn-dom = $ "\#modify-level .canBtn"
	_charge-cancel-confirm-btn-dom = $ "\#modify-recharge .confirm-cancel-btn"
	_level-cancel-confirm-btn-dom = $ "\#modify-level .confirm-cancel-btn"
	_charge-confirm-btn-dom = $ "\#modify-recharge .confirm-btn"
	_level-confirm-btn-dom = $ "\#modify-level .confirm-btn"
	_charge-finish-btn-dom = $ "\.charge-finBtn"
	_level-finish-btn-dom = $ "\.level-finBtn"

	_init-table = (_get-JSON)!->
		all = get-JSON _get-JSON!
		_ladder = all['ladder']
		charge_ladder = all['charge_ladder']
		cashEXP = all['cashEXP']
		$("._tip-1").html("顾客每消费 1 元获得 #{cashEXP} 积分")
		for i from 1 to 5 by 1
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

		_level-cancel-btn-dom.click !->
			$('#modify-level .stop-confirm').fade-in 100

		_charge-cancel-btn-dom.click !->
			$('#modify-recharge .stop-confirm').fade-in 100

		_level-confirm-btn-dom.click !->
			$('#modify-level .stop-confirm').fade-out 100

		_charge-confirm-btn-dom.click !->
			$('#modify-recharge .stop-confirm').fade-out 100

		_level-cancel-confirm-btn-dom.click !->
			$('#modify-level .stop-confirm').fade-out 100
			page.toggle-page "basic"

		_charge-cancel-confirm-btn-dom.click !->
			$('#modify-level .stop-confirm').fade-out 100
			page.toggle-page "basic"

		_level-finish-btn-dom.click !->
			isVaild = 0
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
				if _object.EXP is '' or _object.discout is '' then isVaild++
				_ladder.push(_object)
			request-object.ladder = _ladder
			request-object.cashEXP = cashEXP
			if isVaild is 0
				require_.get("Ladder").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
					}
					callback 	:		(result)!-> location.reload!
				}
			else alert('修改失败')

		_charge-finish-btn-dom.click !->
			isVaild = 0
			request-object = []
			for j from 0 to 4 by 1
				_object = {}
				_object.pay = Number($("._re#{j+1}").val!)
				_object.get = Number($("._re#{j+1}-real").val!)
				_object.EXP = Number($("._gitf#{j+1}-input").val!)
				if _object.EXP is '' or _object.pay is '' or _object.get is '' then isVaild++
				request-object.push(_object)
			if isVaild is 0
				require_.get("Charge").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
					}
					callback 	:		(result)!-> location.reload!
				}
			else alert('修改失败')

	_init-all-blur = !->
		$("._tip-1-input").blur !->
			if $('._tip-1-input').val() == '' or /^[0-9]\d*$/.test($('._tip-1-input').val())
				return true
			else
				$('._tip-1-input').val('')
				alert('消费赠送积分为正整数')
				return false

		$("._lv1-upgrade").blur !->
			if $('._lv1-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv1-upgrade').val())
				if 	$('._lv1-upgrade').val() > $('._lv0-upgrade').val() and $('._lv1-upgrade').val() < $('._lv2-upgrade').val() then return true
				else
					$('._lv1-upgrade').val('')
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv1-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv2-upgrade").blur !->
			if $('._lv2-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv2-upgrade').val())
				if 	$('._lv2-upgrade').val() > $('._lv1-upgrade').val() and $('._lv2-upgrade').val() < $('._lv3-upgrade').val() then return true
				else
					$('._lv2-upgrade').val('')
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv2-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv3-upgrade").blur !->
			if $('._lv3-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv3-upgrade').val())
				if 	$('._lv3-upgrade').val() > $('._lv2-upgrade').val() and $('._lv3-upgrade').val() < $('._lv4-upgrade').val() then return true
				else
					$('._lv3-upgrade').val('')
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv3-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv4-upgrade").blur !->
			if $('._lv4-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv4-upgrade').val())
				if 	$('._lv4-upgrade').val() > $('._lv3-upgrade').val() and $('._lv4-upgrade').val() < $('._lv5-upgrade').val() then return true
				else
					$('._lv4-upgrade').val('')
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv4-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv5-upgrade").blur !->
			if $('._lv5-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv5-upgrade').val())
				if 	$('._lv5-upgrade').val() > $('._lv4-upgrade').val() then return true
				else
					$('._lv5-upgrade').val('')
					alert('升级积分需大于低一级')
					return false
			else
				$('._lv5-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv1-discout").blur !->
			if $('._lv1-discout').val() == '' or /^[0-9]\d*$/.test($('._lv1-discout').val())
				if 	$('._lv1-discout').val() < $('._lv0-discout').val() and $('._lv1-discout').val() > $('._lv2-discout').val() then return true
				else
					$('._lv1-discout').val('')
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv1-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv2-discout").blur !->
			if $('._lv2-discout').val() == '' or /^[0-9]\d*$/.test($('._lv2-discout').val())
				if 	$('._lv2-discout').val() < $('._lv1-discout').val() and $('._lv2-discout').val() > $('._lv3-discout').val() then return true
				else
					$('._lv3-discout').val('')
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv2-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv3-discout").blur !->
			if $('._lv3-discout').val() == '' or /^[0-9]\d*$/.test($('._lv3-discout').val())
				if 	$('._lv3-discout').val() < $('._lv2-discout').val() and $('._lv3-discout').val() > $('._lv4-discout').val() then return true
				else
					$('._lv3-discout').val('')
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv3-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv4-discout").blur !->
			if $('._lv4-discout').val() == '' or /^[0-9]\d*$/.test($('._lv4-discout').val())
				if 	$('._lv4-discout').val() < $('._lv3-discout').val() and $('._lv4-discout').val() > $('._lv5-discout').val() then return true
				else
					$('._lv4-discout').val('')
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv4-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv5-discout").blur !->
			if $('._lv5-discout').val() == '' or /^[0-9]\d*$/.test($('._lv5-discout').val())
				if 	$('._lv5-discout').val() < $('._lv4-discout').val() then return true
				else
					$('._lv5-discout').val('')
					alert('折扣百分比需小于低一级')
					return false
			else
				$('._lv5-discout').val('')
				alert('折扣百分比为正整数')
				return false

	time-out-id = ''
	# 显示全局信息提示
	show-global-message = (str)->
		ob = $ '#global_message' 
		ob.show!
		ob.html str 
		clearTimeout time-out-id
		time-out-id := setTimeout('$("#global_message").fadeOut(300)',2000)

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"


	initial: (_get-JSON)!->
		_init-all-blur!
		_init-table _get-JSON
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage