main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = null
	value = []
	dayAry = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
	test = 0
	payAry = ["微信支付", "现金支付"]
	_modifyForBus-dom = $ "\#modifyForBus"
	_cancel-dom = $ "\.canBtn"
	_finish-dom = $ "\.finBtn"
	_run-dom = $ "\.run-btn"
	_stop-dom = $ "\.stop-btn"
	_weekday-dom = $ "\.weekday input"
	_payment-dom = $ "\.payment input"

	_init-all-event = !->
		_modifyForBus-dom.click !->
			page.toggle-page "mod"
		_finish-dom.click !->
			_save-form-value!
			_show-form-value!
			page.toggle-page "pre"
		_cancel-dom.click !->
			page.toggle-page "pre"
		_run-dom.click !->
			$('#runBusiness').removeClass "free"
			$('#runBusiness').addClass "choose"
			$('#stopBusiness').removeClass "choose"
			$('#stopBusiness').addClass "free"
			$('#runMes').html('业务已启用')
			$('#stopMes').html('停用本业务')
			$('#previewBusiness').css("color", '#333333')
			$('#previewBusiness').css("border-color", '#333333')
		_stop-dom.click !->
			$('#runBusiness').removeClass "choose"
			$('#runBusiness').addClass "free"
			$('#stopBusiness').removeClass "free"
			$('#stopBusiness').addClass "choose"
			$('#runMes').html('启用本业务')
			$('#stopMes').html('业务已停用')
			$('#previewBusiness').css("color", '#E7E7EB')
			$('#previewBusiness').css("border-color", '#E7E7EB')
		_weekday-dom.click !->
			_weekday = $(this).parent()
			if $(_weekday).hasClass("true")
				$(_weekday).removeClass "true"
				$(_weekday).addClass "false"
			else if $(_weekday).hasClass("false")
				$(_weekday).removeClass "false"
				$(_weekday).addClass "true"
		_payment-dom.click !->
			_payment = $(this).parent()
			if $(_payment).hasClass("true")
				$(_payment).removeClass "true"
				$(_payment).addClass "false"
			else if $(_payment).hasClass("false")
				$(_payment).removeClass "false"
				$(_payment).addClass "true"

	_show-form-value = ->

	_save-form-value = ->

	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_save-form-value!
		_show-form-value!
		_init-all-event!
		_init-depend-module!

module.exports = main-manage
