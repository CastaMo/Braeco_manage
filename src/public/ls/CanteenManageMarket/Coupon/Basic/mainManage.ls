main-manage = let
	page = null

	_apply-dom = $ "\.apply input"
	_run-btn-dom = $ "\.run-btn"
	_stop-btn-dom = $ "\.stop-btn"
	_new-btn-dom = $ "\.new-btn"
	_cancel-btn-dom = $ "\.cancel-btn"
	_save-btn-dom = $ "\.save-btn"

	_init-all-event = !->
		$('#datepickeer').datepicker();
		_apply-dom.click !->
			_apply = $(this).parent()
			if _apply.hasClass("true")
				_apply.removeClass "true"
				_apply.addClass "false"
			else if _apply.hasClass("false")
				_apply.removeClass "false"
				_apply.addClass "true"

		_new-btn-dom.click !->
			page.toggle-page "new"

		_cancel-btn-dom.click !->
			page.toggle-page "basic"

		_save-btn-dom.click !->
			page.toggle-page "basic"

		_run-btn-dom.click !->
			$('#run-coupon').removeClass "free"
			$('#run-coupon').addClass "choose"
			$('#stop-coupo').removeClass "choose"
			$('#stop-coupon').addClass "free"
			$('#run-coupon p').html("启用发放中")
			$('#stop-coupon p').html("停止发放")
			$('#detailCoupon-content').css("color", "#9B9B9B")

		_stop-btn-dom.click !->
			$('#run-coupon').removeClass "choose"
			$('#run-coupon').addClass "free"
			$('#stop-coupon').removeClass "free"
			$('#stop-coupon').addClass "choose"
			$('#run-coupon p').html("启用发放")
			$('#stop-coupon p').html("停止发放中")
			$('#detailCoupon-content').css("color", "#4A4A4A")

	_init-all-keyup = !->
		$("._face-value").keyup !->
			$("._pre-face-value").html($("._face-value").val!)
		$("._use-condition").keyup !->
			$(".pre-condition-value").html($("._use-condition").val!)
			$(".tip-3-content").html("3. 订单消费满 ￥#{$("._use-condition").val!} 可用，最多可同时使用 #{$("._multiple-use").val!} 张。")
		$("._max-own").keyup !->
			$(".tip-2-content").html("2. 每个微信号限领取 #{$("._max-own").val!} 张代金券；")
		$("._multiple-use").keyup !->
			$(".tip-3-content").html("3. 订单消费满 ￥#{$("._use-condition").val!} 可用，最多可同时使用 #{$("._multiple-use").val!} 张。")
		


	_init-depend-module = !->
		page := require "./pageManage.js"


	initial: !->
		_init-depend-module!
		_init-all-event!
		_init-all-keyup!

 
module.exports = main-manage