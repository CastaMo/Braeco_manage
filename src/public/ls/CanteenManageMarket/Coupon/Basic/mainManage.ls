main-manage = let
	page = null

	_apply-dom = $ "\.apply input"

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