main-manage = let
	page = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	_coupons = []
	_length = ""
	_apply-dom = $ "\.apply input"
	_date-period-start-dom = $ "\._date-period-start"
	_date-period-end-dom = $ "\._date-period-end"
	_run-btn-dom = $ "\.run-btn"
	_stop-btn-dom = $ "\.stop-btn"
	_new-btn-dom = $ "\.new-btn"
	_cancel-btn-dom = $ "\.cancel-btn"
	_save-btn-dom = $ "\.save-btn"
	_run-content-dom = $ "\#run-content-field"
	_pass-content-dom = $ "\#pass-content-field"
	_confirm-btn-dom = $ "\.confirm-btn"
	_confirm-cancel-btn = $ "\.confirm-cancel-btn"

	class Coupon
		(options)!->
			deep-copy options, @
			_coupons.push @

	_init-arry = !->
		couponArrJSON = $('#json-field').html!
		couponArr = []
		couponArr = JSON.parse(couponArrJSON)
		for coupon in couponArr
			new Coupon(coupon)

	_init-coupon-view = !->
		_length = _coupons.length
		for i from 0 to _length-1 by 1
			_new-dom = $ "<div class='coupon' class='btn'>
							<div class='coupon-identify'>
								<span class='coupon-batch-number'></span>
								<span class='coupon-status'></span>
							</div>
							<div class='coupon-info'>
								<p class='coupon-value'></p>
								<p class='coupon-max-use'></p>
								<p class='coupon-valid-period'></p>
							</div>
						</div>"
			_new-dom.find(".coupon-batch-number").html("批次号：#{_coupons[i].couponid}")
			_new-dom.find(".coupon-max-use").html("最多可叠加使用#{_coupons[i].max_use}张")
			_new-dom.find(".coupon-value").html("#{_coupons[i].cost_reduce}元（满#{_coupons[i].cost}元可用）")
			if _coupons[i].indate.length is 20
				_new-dom.find(".coupon-valid-period").html("#{_coupons[i].indate.substr(10)} 至 #{_coupons[i].indate.substr(10,20)}")
			else if _coupons[i].indate.length isnt 20
				_new-dom.find(".coupon-valid-period").html("领取后#{_coupons[i].indate}天有效，过期无效")
			if _coupons[i].status == "0"
				_new-dom.find(".coupon-status").html("发放中")
				_new-dom.find(".coupon-status").css("color","#00C049")
				_run-content-dom.last().append _new-dom
			else if _coupons[i].status == "1"
				_new-dom.find(".coupon-status").html("已过期")
				_pass-content-dom.last().append _new-dom
			else if _coupons[i].status == "2"
				_new-dom.find(".coupon-status").html("停用中")
				_new-dom.find(".coupon-status").css("color","rgb(235,79,16)")
				_run-content-dom.last().append _new-dom
			_new-dom.click !->
				for j from 0 to _length-1 by 1
					_checkid = $(@).find('.coupon-batch-number').html!
					if Number(_checkid.substr(4,20)) is Number(_coupons[j].couponid)
						if Number(_coupons[j].status) is 0
							$(".run-btn p").html("启用发放中")
							$(".stop-btn p").html("停止发放")
							$(".detailCoupon-wrapper").removeClass "stop"
							$(".detailCoupon-wrapper").removeClass "pass"
							$(".detailCoupon-wrapper").addClass "run"
						else if Number(_coupons[j].status) is 1
							$(".detailCoupon-wrapper").removeClass "run"
							$(".detailCoupon-wrapper").removeClass "stop"
							$(".detailCoupon-wrapper").addClass "pass"
						else if Number(_coupons[j].status) is 2
							$(".run-btn p").html("启用发放")
							$(".stop-btn p").html("停止发放中")
							$(".detailCoupon-wrapper").removeClass "run"
							$(".detailCoupon-wrapper").removeClass "pass"
							$(".detailCoupon-wrapper").addClass "stop"
						$("._pre-batch-number").html("#{_coupons[j].couponid}")
						$("._pre-coupon-inventory").html("#{_coupons[j].couponid}")
						$("._pre-face-value").html("#{_coupons[j].cost_reduce}")
						if _coupons[i].indate.length is 20
							$("._pre-valid-period").html("#{_coupons[i].indate.substr(10)} 至 #{_coupons[i].indate.substr(10,20)}")
						else if _coupons[i].indate.length isnt 20
							$("._pre-valid-period").html("领取后#{_coupons[i].indate}天有效，过期无效")
						$("._pre-use-condition").html("订单额满#{_coupons[i].cost}元可使用")
						$("._left-distribute-coupon").html("顾客点餐前弹出领取页面")
						$("._pre-max-coupon").html("100000张")
						$("._pre-max-own").html("每人最多领取1张")
						$("._pre-apply-area").html("堂食 预订 外卖")
						$("._pre-multiple-use").html("每笔订单最多同时叠加使用#{_coupons[j].max_use}张")
						$("._pre-distribute-coupon").html("顾客点餐前弹出领取页面")
				page.toggle-page "detail"
				

	_init-all-event = !->
		$("._date-period input").datepicker ({
			format: 'yyyy-mm-dd'
			autohide: 'true'
			autopick: 'true'
		});
		
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
			$(".detailCoupon-wrapper").removeClass "stop"
			$(".detailCoupon-wrapper").addClass "run"
			$(".run-btn p").html("启用发放中")
			$(".stop-btn p").html("停止发放")

		_stop-btn-dom.click !->
			$(".stop-confirm").fade-in 100

		_confirm-btn-dom.click !->
			$(".detailCoupon-wrapper").removeClass "run"
			$(".detailCoupon-wrapper").addClass "stop"
			$(".run-btn p").html("启用发放")
			$(".stop-btn p").html("停止发放中")
			$(".stop-confirm").fade-out 100

		_confirm-cancel-btn.click !->
			$(".stop-confirm").fade-out 100

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
		_date-period-start-dom.mouseup !->
			console.log "111", 111
			if _date-period-start-dom.val! isnt ""
				$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")
		_date-period-end-dom.mouseup !->
			console.log "111", 111
			if _date-period-end-dom.val! isnt ""
				$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")


	_init-depend-module = !->
		page := require "./pageManage.js"


	initial: !->
		_init-arry!
		_init-coupon-view!
		_init-depend-module!
		_init-all-event!
		_init-all-keyup!

 
module.exports = main-manage