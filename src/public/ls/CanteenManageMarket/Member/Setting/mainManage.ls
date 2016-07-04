main-manage = let
	page = require_ = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	charge_ladder = []
	cashEXP = ""
	_check-lv-valid = 0
	_check-ch-valid = 0
	_check-re-valid = 0
	_check-real-valid = 0
	_check-gift-valid = 0
	_check-gift = 0
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
		_ladder := all['ladder']
		charge_ladder := all['charge_ladder']
		cashEXP := all['cashEXP']
		$("._tip-1").html("顾客每消费 1 元获得 #{cashEXP} 积分")
		for i from 1 to 5 by 1
			$("\#level-table tr").eq(i+1).children("td").eq(0).html("LV#{i}.#{_ladder[i].name}")
			$("\#level-table tr").eq(i+1).children("td").eq(1).html("#{_ladder[i].EXP}")
			$("\#level-table tr").eq(i+1).children("td").eq(2).html("#{_ladder[i].discount}% （#{_ladder[i].discount/10}折）")
			$("._lv#{i}-upgrade").val(_ladder[i].EXP)
			$("._lv#{i}-discout").val(_ladder[i].discount)
			$("\#level-#{i} ._tip-2-discout").html("#{_ladder[i].discount/10} 折")
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
			for i from 1 to 5 by 1
				$("._lv#{i}-upgrade").val(_ladder[i].EXP)
				$("._lv#{i}-discout").val(_ladder[i].discount)
			page.toggle-page "modify-level"

		_recharge-modify-btn-dom.click !->
			for j from 0 to 4 by 1
				$("._re#{j+1}").val(charge_ladder[j].pay)
				$("._re#{j+1}-real").val(charge_ladder[j].get)
				$("._gitf#{j+1}-input").val(charge_ladder[j].EXP)
			page.toggle-page "modify-recharge"

		_level-cancel-btn-dom.click !->
			$('#modify-level .stop-confirm').fade-in 100
			$('#modify-level .confirm-mask').fade-in 100

		_charge-cancel-btn-dom.click !->
			$('#modify-recharge .stop-confirm').fade-in 100
			$('#modify-recharge .confirm-mask').fade-in 100

		_level-confirm-btn-dom.click !->
			$('#modify-level .stop-confirm').fade-out 100
			$('#modify-level .confirm-mask').fade-out 100

		_charge-confirm-btn-dom.click !->
			$('#modify-recharge .stop-confirm').fade-out 100
			$('#modify-recharge .confirm-mask').fade-out 100

		_level-cancel-confirm-btn-dom.click !->
			$('#modify-level .stop-confirm').fade-out 100
			$('#modify-level .confirm-mask').fade-out 100
			page.toggle-page "basic"

		_charge-cancel-confirm-btn-dom.click !->
			$('#modify-recharge .stop-confirm').fade-out 100
			$('#modify-recharge .confirm-mask').fade-out 100
			page.toggle-page "basic"

		_level-finish-btn-dom.click !->
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
			request-object.ladder = _ladder
			request-object.cashEXP = cashEXP
			if _check-lv-valid is 0 and _check-ch-valid is 0 and _check-gift is 0
				require_.get("Ladder").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
					}
					callback 	:		(result)!-> alert('修改成功', true);setTimeout('location.reload()', 2000)
				}
			else alert('修改失败，请注意各项大小')

		_charge-finish-btn-dom.click !->
			request-object = []
			for j from 0 to 4 by 1
				_object = {}
				_object.pay = Number($("._re#{j+1}").val!)
				_object.get = Number($("._re#{j+1}-real").val!)
				_object.EXP = Number($("._gitf#{j+1}-input").val!)
				request-object.push(_object)
			if _check-re-valid is 0 and _check-real-valid is 0 and _check-gift-valid is 0
				require_.get("Charge").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
					}
					callback 	:		(result)!-> alert('修改成功', true);setTimeout('location.reload()', 2000)
				}
			else alert('修改失败，请注意各项大小')

	_init-all-blur = !->
		$("._tip-1-input").blur !->
			if $('._tip-1-input').val() == '' or /^[0-9]\d*$/.test($('._tip-1-input').val())
				if $('._tip-1-input').val() < 100
					_check-gift := 0
					return true
				else
					_check-gift := 1
					$('._tip-1-input').val('')
					alert('消费赠送积分为正整数，范围 0-100')
					return false
			else
				$('._tip-1-input').val('')
				alert('消费赠送积分为正整数')
				return false

		$("._lv1-upgrade").blur !->
			if $('._lv1-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv1-upgrade').val())
				if Number($('._lv1-upgrade').val()) > Number($('._lv0-upgrade').val()) and Number($('._lv1-upgrade').val()) < Number($('._lv2-upgrade').val()) then _check-lv-valid := 0;return true
				else
					_check-lv-valid := 1
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv1-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv2-upgrade").blur !->
			if $('._lv2-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv2-upgrade').val())
				if Number($('._lv2-upgrade').val()) > Number($('._lv1-upgrade').val()) and Number($('._lv2-upgrade').val()) < Number($('._lv3-upgrade').val()) then _check-lv-valid := 0;return true
				else
					_check-lv-valid := 1
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv2-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv3-upgrade").blur !->
			if $('._lv3-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv3-upgrade').val())
				if Number($('._lv3-upgrade').val()) > Number($('._lv2-upgrade').val()) and Number($('._lv3-upgrade').val()) < Number($('._lv4-upgrade').val()) then _check-lv-valid := 0;return true
				else
					_check-lv-valid := 1
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv3-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv4-upgrade").blur !->
			if $('._lv4-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv4-upgrade').val())
				if Number($('._lv4-upgrade').val()) > Number($('._lv3-upgrade').val()) and Number($('._lv4-upgrade').val()) < Number($('._lv5-upgrade').val()) then _check-lv-valid := 0;return true
				else
					_check-lv-valid := 1
					alert('升级积分需大于低一级，小于高一级')
					return false
			else
				$('._lv4-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv5-upgrade").blur !->
			if $('._lv5-upgrade').val() == '' or /^[0-9]\d*$/.test($('._lv5-upgrade').val())
				if Number($('._lv5-upgrade').val()) > Number($('._lv4-upgrade').val()) then _check-lv-valid := 0;return true
				else
					_check-lv-valid := 1
					alert('升级积分需大于低一级')
					return false
			else
				$('._lv5-upgrade').val('')
				alert('升级积分为正整数')
				return false

		$("._lv1-discout").blur !->
			if $('._lv1-discout').val() == '' or /^[0-9]\d*$/.test($('._lv1-discout').val())
				if Number($('._lv1-discout').val()) < Number($('._lv0-discout').val()) and Number($('._lv1-discout').val()) > Number($('._lv2-discout').val()) then _check-ch-valid := 0;return true
				else
					_check-ch-valid := 1
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv1-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv2-discout").blur !->
			if $('._lv2-discout').val() == '' or /^[0-9]\d*$/.test($('._lv2-discout').val())
				if Number($('._lv2-discout').val()) < Number($('._lv1-discout').val()) and Number($('._lv2-discout').val()) > Number($('._lv3-discout').val()) then _check-ch-valid := 0;return true
				else
					_check-ch-valid := 1
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv2-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv3-discout").blur !->
			if $('._lv3-discout').val() == '' or /^[0-9]\d*$/.test($('._lv3-discout').val())
				if Number($('._lv3-discout').val()) < Number($('._lv2-discout').val()) and Number($('._lv3-discout').val()) > Number($('._lv4-discout').val()) then _check-ch-valid := 0;return true
				else
					_check-ch-valid := 1
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv3-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv4-discout").blur !->
			if $('._lv4-discout').val() == '' or /^[0-9]\d*$/.test($('._lv4-discout').val())
				if Number($('._lv4-discout').val()) < Number($('._lv3-discout').val()) and Number($('._lv4-discout').val()) > Number($('._lv5-discout').val()) then _check-ch-valid := 0;return true
				else
					_check-ch-valid := 1
					alert('折扣百分比需小于低一级，大于高一级')
					return false
			else
				$('._lv4-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._lv5-discout").blur !->
			if $('._lv5-discout').val() == '' or /^[0-9]\d*$/.test($('._lv5-discout').val())
				if Number($('._lv5-discout').val()) < Number($('._lv4-discout').val()) then _check-ch-valid := 0;return true
				else
					_check-ch-valid := 1
					alert('折扣百分比需小于低一级')
					return false
			else
				$('._lv5-discout').val('')
				alert('折扣百分比为正整数')
				return false

		$("._re1").blur !->
			if $('._re1').val() == '' or /^[0-9]\d*$/.test($('._re1').val())
				if Number($('._re1').val()) < Number($('._re2').val()) then _check-re-valid := 0;return true
				else
					_check-re-valid := 1
					alert('充值金额需小于下一项')
					return false
			else
				$('._re1').val('')
				alert('充值金额为正整数')
				return false

		$("._re2").blur !->
			if $('._re2').val() == '' or /^[0-9]\d*$/.test($('._re2').val())
				if Number($('._re2').val()) < Number($('._re3').val()) and Number($('._re2').val()) > Number($('._re1').val()) then _check-re-valid := 0;return true
				else
					_check-re-valid := 1
					alert('充值金额需大于上一项，小于下一项')
					return false
			else
				$('._re2').val('')
				alert('充值金额为正整数')
				return false

		$("._re3").blur !->
			if $('._re3').val() == '' or /^[0-9]\d*$/.test($('._re3').val())
				if Number($('._re3').val()) < Number($('._re4').val()) and Number($('._re3').val()) > Number($('._re2').val()) then _check-re-valid := 0;return true
				else
					_check-re-valid := 1
					alert('充值金额需大于上一项，小于下一项')
					return false
			else
				$('._re3').val('')
				alert('充值金额为正整数')
				return false

		$("._re4").blur !->
			if $('._re4').val() == '' or /^[0-9]\d*$/.test($('._re4').val())
				if Number($('._re4').val()) < Number($('._re5').val()) and Number($('._re4').val()) > Number($('._re3').val()) then _check-re-valid := 0;return true
				else
					_check-re-valid := 1
					alert('充值金额需大于上一项，小于下一项')
					return false
			else
				$('._re4').val('')
				alert('充值金额为正整数')
				return false

		$("._re5").blur !->
			if $('._re5').val() == '' or /^[0-9]\d*$/.test($('._re5').val())
				if Number($('._re5').val()) > Number($('._re4').val()) then _check-re-valid := 0;return true
				else
					_check-re-valid := 1
					alert('充值金额需大于上一项')
					return false
			else
				$('._re5').val('')
				alert('充值金额为正整数')
				return false

		$("._re1-real").blur !->
			if $('._re1-real').val() == '' or /^[0-9]\d*$/.test($('._re1-real').val())
				if Number($('._re1-real').val()) < Number($('._re2-real').val())
					if Number($('._re1-real').val()) >= Number($('._re1').val())
						_check-real-valid := 0
						return true
					else 
						_check-real-valid := 1
						alert('实际充值金额需大于等于充值金额')
						return false
				else
					_check-real-valid := 1
					alert('实际充值金额需大于上一项，小于下一项')
					return false
			else
				$('._re1-real').val('')
				alert('实际充值金额为正整数')
				return false

		$("._re2-real").blur !->
			if $('._re2-real').val() == '' or /^[0-9]\d*$/.test($('._re2-real').val())
				if Number($('._re2-real').val()) < Number($('._re3-real').val()) and Number($('._re2-real').val()) > Number($('._re1-real').val())
					if Number($('._re2-real').val()) >= Number($('._re2').val())
						_check-real-valid := 0
						return true
					else 
						_check-real-valid := 1
						alert('实际充值金额需大于等于充值金额')
						return false
			else
				$('._re2-real').val('')
				alert('实际充值金额为正整数')
				return false

		$("._re3-real").blur !->
			if $('._re3-real').val() == '' or /^[0-9]\d*$/.test($('._re3-real').val())
				if Number($('._re3-real').val()) < Number($('._re4-real').val()) and Number($('._re3-real').val()) > Number($('._re2-real').val())
					if Number($('._re3-real').val()) >= Number($('._re3').val())
						_check-real-valid := 0
						return true
					else 
						_check-real-valid := 1
						alert('实际充值金额需大于等于充值金额')
						return false
			else
				$('._re3-real').val('')
				alert('实际充值金额为正整数')
				return false

		$("._re4-real").blur !->
			if $('._re4-real').val() == '' or /^[0-9]\d*$/.test($('._re4-real').val())
				if Number($('._re4-real').val()) < Number($('._re5-real').val()) and Number($('._re4-real').val()) > Number($('._re3-real').val())
					if Number($('._re4-real').val()) >= Number($('._re4').val())
						_check-real-valid := 0
						return true
					else 
						_check-real-valid := 1
						alert('实际充值金额需大于等于充值金额')
						return false
			else
				$('._re4-real').val('')
				alert('实际充值金额为正整数')
				return false

		$("._re5-real").blur !->
			if $('._re5-real').val() == '' or /^[0-9]\d*$/.test($('._re5-real').val())
				if Number($('._re5-real').val()) > Number($('._re4-real').val())
					if Number($('._re5-real').val()) >= Number($('._re5').val())
						_check-real-valid := 0
						return true
					else 
						_check-real-valid := 1
						alert('实际充值金额需大于等于充值金额')
						return false
			else
				$('._re5-real').val('')
				alert('实际充值金额为正整数')
				return false

		$("._gift1-input").blur !->
			if $('._gift1-input').val() == '' or /^[0-9]\d*$/.test($('._gift1-input').val())
				if Number($('._gift1-input').val()) < Number($('._gift2-input').val()) then _check-gift-valid := 0;return true
				else
					_check-gift-valid := 1
					alert('赠送积分需小于下一项')
					return false
			else
				$('._gift1-input').val('')
				alert('赠送积分为正整数')
				return false

		$("._gift2-input").blur !->
			if $('._gift2-input').val() == '' or /^[0-9]\d*$/.test($('._gift2-input').val())
				if Number($('._gift2-input').val()) < Number($('._gift3-input').val()) and Number($('._gift2-input').val()) > Number($('._gift1-input').val()) then _check-gift-valid := 0;return true
				else
					_check-gift-valid := 1
					alert('赠送积分需大于上一项，小于下一项')
					return false
			else
				$('._gift2-input').val('')
				alert('赠送积分为正整数')
				return false

		$("._gift3-input").blur !->
			if $('._gift3-input').val() == '' or /^[0-9]\d*$/.test($('._gift3-input').val())
				if Number($('._gift3-input').val()) < Number($('._gift4-input').val()) and Number($('._gift3-input').val()) > Number($('._gift2-input').val()) then _check-gift-valid := 0;return true
				else
					_check-gift-valid := 1
					alert('赠送积分需大于上一项，小于下一项')
					return false
			else
				$('._gift3-input').val('')
				alert('赠送积分为正整数')
				return false

		$("._gift4-input").blur !->
			if $('._gift4-input').val() == '' or /^[0-9]\d*$/.test($('._gift4-input').val())
				if Number($('._gift4-input').val()) < Number($('._gift5-input').val()) and Number($('._gift4-input').val()) > Number($('._gift3-input').val()) then _check-gift-valid := 0;return true
				else
					_check-gift-valid := 1
					alert('赠送积分需大于上一项，小于下一项')
					return false
			else
				$('._gift4-input').val('')
				alert('赠送积分为正整数')
				return false

		$("._gift5-input").blur !->
			if $('._gift5-input').val() == '' or /^[0-9]\d*$/.test($('._gift5-input').val())
				if Number($('._gift5-input').val()) > Number($('._gift4-input').val()) then _check-gift-valid := 0;return true
				else
					_check-gift-valid := 1
					alert('赠送积分需大于上一项')
					return false
			else
				$('._gift5-input').val('')
				alert('赠送积分为正整数')
				return false

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"


	initial: (_get-JSON)!->
		_init-all-blur!
		_init-table _get-JSON
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage