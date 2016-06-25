main-manage = let
	page = require_ = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	_coupons = []
	_length = ""
	_upsum = null
	_upnow = null
	_downsum = null
	_downnow = null
	_jumpPage = null
	_apply-dom = $ "\.apply input"
	_face-value-dom = $ "\._face-value"
	_valid-period-dom = $ "\._valid-period"
	_valid-day-dom = $ "\._valid-day"
	_use-condition-dom = $ "\._use-condition"
	_max-coupon-dom = $ "\._max-coupon"
	_distribute-coupon-dom = $ "\._distribute-coupon"
	_max-own-dom = $ "\._max-own"
	_max-own-select-dom = $ "\.max-own-select"
	_multiple-use-dom = $ "\._multiple-use"
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
	_up-last-dom = $ "\._up .lastPage.btn"
	_up-next-dom = $ "\._up .nextPage.btn"
	_up-jump-dom = $ "\._up .jumpPage.btn"
	_down-last-dom = $ "\._down .lastPage.btn"
	_down-next-dom = $ "\._down .nextPage.btn"
	_down-jump-dom = $ "\._down .jumpPage.btn"

	class Coupon
		(options)->
			deep-copy options, @
			@init!
			_coupons.push @
		init: !->

	_init-all-coupon = !->
		couponArrJSON = $('#json-field').html!
		console.log "couponArrJSON", couponArrJSON
		_test = '{"0":[{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/2eb8f0fd16faedf3c823542e1512ffb22e0e5b73.png","fun":"7","couponid":"19","indate":"2016-06-062016-06-06"},{"quantity":"3","remain":"3","cost":"3","cost_reduce":"12","description":null,"status":"0","daily":"0","max":"2","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/f86eb3aef5c7f98b14365d559e3c4acff9ff3d92.png","fun":"3","couponid":"18","indate":"3"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"2","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/32fba3f289c338ca3d276c553aace573dad54fb1.png","fun":"7","couponid":"17","indate":"2016-06-062016-06-29"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/0a0c6242d75b3964c79125ae54584fc5941274ba.png","fun":"3","couponid":"16","indate":"2016-06-062016-06-08"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/2eb8f0fd16faedf3c823542e1512ffb22e0e5b73.png","fun":"7","couponid":"19","indate":"2016-06-062016-06-06"},{"quantity":"3","remain":"3","cost":"3","cost_reduce":"12","description":null,"status":"0","daily":"0","max":"2","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/f86eb3aef5c7f98b14365d559e3c4acff9ff3d92.png","fun":"3","couponid":"18","indate":"3"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"2","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/32fba3f289c338ca3d276c553aace573dad54fb1.png","fun":"7","couponid":"17","indate":"2016-06-062016-06-29"},{"quantity":"1","remain":"1","cost":"1","cost_reduce":"1","description":null,"status":"1","daily":"0","max":"1","max_use":"1","pay":"0","url":"http:\/\/devel.brae.co\/public\/images\/qrcode\/coupon\/0a0c6242d75b3964c79125ae54584fc5941274ba.png","fun":"3","couponid":"16","indate":"2016-06-062016-06-08"}],"upsum":10,"upnow":1,"downsum":1}'
		all-coupons = []
		all-coupons = JSON.parse(couponArrJSON)[0]
		_upsum := JSON.parse(couponArrJSON)['upsum']
		_upnow := JSON.parse(couponArrJSON)['upnow']
		_downsum := JSON.parse(couponArrJSON)['downsum']
		_downnow := JSON.parse(couponArrJSON)['downnow']
		console.log "all-coupons", all-coupons
		for coupon in all-coupons
			new Coupon {
				couponid 			:		coupon.couponid
				status 				:		coupon.status
				cost 				: 		coupon.cost
				cost_reduce 		:		coupon.cost_reduce
				max 				:		coupon.max
				max_use 			:		coupon.max_use
				indate 				:		coupon.indate
				remain				:		coupon.remain
				daily				:		coupon.daily
				fun 				: 		coupon.fun
				pay 				:		coupon.pay
				quantity 			:		coupon.quantity
				url					:		coupon.url
			}

	_init-coupon-view = !->
		_length = _coupons.length
		for i from 0 to _length-1 by 1
			$("._up .page").html("#{_upnow}/#{_upsum}")
			$("._down .page").html("#{_downnow}/#{_downsum}")
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
				_new-dom.find(".coupon-valid-period").html("#{_coupons[i].indate.substr(0, 10)} 至 #{_coupons[i].indate.substr(10,20)}")
			else if _coupons[i].indate.length < 10
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
				_hello = 0
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
						$("._pre-coupon-inventory").html("#{_coupons[j].remain}")
						$("._pre-face-value").html("#{_coupons[j].cost_reduce}")
						if _coupons[j].indate.length is 20
							$("._pre-valid-period").html("#{_coupons[j].indate.substr(10)} 至 #{_coupons[j].indate.substr(10,20)}")
						else if _coupons[j].indate.length isnt 20
							$("._pre-valid-period").html("领取后#{_coupons[j].indate}天有效，过期无效")
						$("._pre-use-condition").html("订单额满#{_coupons[j].cost}元可使用")
						if Number(_coupons[j].pay) is 0
							$("._left-distribute-coupon").html("顾客点餐前发券")
							$("._pre-distribute-coupon").html("顾客点餐前发券")
						else if Number(_coupons[j].pay) is 1
							$("._left-distribute-coupon").html("顾客支付订单后发券")
							$("._pre-distribute-coupon").html("顾客支付订单后发券")
						$("._pre-max-coupon").html("#{_coupons[j].quantity}张")
						$("._pre-max-own").html("每人最多领取#{_coupons[j].max}张")
						_fun = ""
						_func = ["堂食 ", "预订 ", "外卖 ", "外带"]
						_hello = parseInt(_coupons[j].fun).toString(2)
						for x from 0 to _hello.length-1 by 1
							if _hello[x] is "1"
								_fun += _func[x]
						$("._pre-apply-area").html(_fun)
						$("._pre-multiple-use").html("每笔订单最多同时叠加使用#{_coupons[j].max_use}张")
						$("._QRcode").attr("src", "#{_coupons[j].url}")
				page.toggle-page "detail"

	_init-all-event = !->
		$("._date-period input").datepicker ({
			format: 'yyyy-mm-dd'
			autohide: 'true'
			autopick: 'true'
		});
		
		_up-last-dom.click !->
			if _upnow > 1 then _upnow--
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

		_down-last-dom.click !->
			if _downnow > 1 then _downnow--
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

		_up-next-dom.click !->
			if _upnow < _upsum then _upnow++
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

		_down-next-dom.click !->
			if _downnow < _downsum then _downnow++
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

		_up-jump-dom.click !->
			_jumpPage = $(".up ._jump-input").val!
			if _jumpPage >= 1 and _jumpPage <= _upsum then _upnow = _jumpPage
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

		_down-jump-dom.click !->
			_jumpPage = $(".down ._jump-input").val!
			if _jumpPage >= 1 and _jumpPage <= _downsum then _downnow = _jumpPage
			location.href = "/Manage/Market/Coupon/Basic?uppn=#{_upnow}&downpn=#{_downnow}"

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
			addCoupon = {}
			fun = []
			_sum = 0
			addCoupon.cost_reduce = $("._face-value").val!
			addCoupon.cost = $("._use-condition").val!
			if $("._valid-period").val! is "0"
				addCoupon.indate = _date-period-start-dom.val!
				addCoupon.indate += _date-period-end-dom.val!
			else if $("._valid-period").val! is "1"
				addCoupon.indate = $("._valid-day").val!
			if $("._fun1").is(':checked') is true
				fun.push(1)
			else if $("._fun1").is(':checked') isnt true
				fun.push(0)
			_sum += fun[0]
			if $("._fun2").is(':checked') is true
				fun.push(1)
			else if $("._fun2").is(':checked') isnt true
				fun.push(0)
			_sum += fun[1]*2
			if $("._fun3").is(':checked') is true
				fun.push(1)
			else if $("._fun3").is(':checked') isnt true
				fun.push(0)
			_sum += fun[2]*4
			if $("._fun4").is(':checked') is true
				fun.push(1)
			else if $("._fun4").is(':checked') isnt true
				fun.push(0)
			_sum += fun[3]*8
			addCoupon.fun = _sum
			addCoupon.quantity = $("._max-coupon").val!
			addCoupon.max_use = $("._multiple-use").val!
			addCoupon.max = $("._max-own").val!
			addCoupon.daily = $("._max-own-select").val!
			addCoupon.pay = $("._distribute-coupon").val!
			request-object = {}
			request-object = addCoupon
			require_.get("add").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				success 	:		(result)!-> location.reload!
			}
			page.toggle-page "basic"

		_run-btn-dom.click !->
			$(".detailCoupon-wrapper").removeClass "stop"
			$(".detailCoupon-wrapper").addClass "run"
			$(".run-btn p").html("启用发放中")
			$(".stop-btn p").html("停止发放")
			request-object = {}
			request-object.status = 0
			_object = {}
			_couponid = $("._pre-batch-number")html!
			request-object.couponlist = []
			_object = {"couponid": _couponid}
			request-object.couponlist.push(_object)
			require_.get("modify").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				success 	:		(result)!-> location.reload!
			}

		_stop-btn-dom.click !->
			if $(".detailCoupon-wrapper").hasClass "run"
				$(".stop-confirm").fade-in 100

		_confirm-btn-dom.click !->
			$(".stop-confirm").fade-out 100
			$(".detailCoupon-wrapper").removeClass "run"
			$(".detailCoupon-wrapper").addClass "stop"
			$(".run-btn p").html("启用发放")
			$(".stop-btn p").html("停止发放中")
			request-object = {}
			request-object.status = 2
			_couponid = $("._pre-batch-number")html!
			request-object.couponlist = []
			_object = {"couponid": _couponid}
			request-object.couponlist.push(_object)
			require_.get("modify").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				success 	:		(result)!-> location.reload!
			}

		_confirm-cancel-btn.click !->
			$(".stop-confirm").fade-out 100

	_init-all-keyup = !->
		_face-value-dom.keyup !->
			$("._pre-face-value").html($("._face-value").val!)
		_valid-period-dom.change !->
			if Number($(@).val!) is 0
				$('#valid-day').fade-out 100
				$('#date-period').fade-in 100
			else if Number($(@).val!) is 1
				$('#date-period').fade-out 100
				$('#valid-day').fade-in 100
		_valid-day-dom.keyup !->
			$(".valid-day-input-tip").html("领取后#{_valid-day-dom.val!}天有效，过期无效")
		_use-condition-dom.keyup !->
			$(".pre-condition-value").html($("._use-condition").val!)
			$(".tip-3-content").html("3. 订单消费满 ￥#{$("._use-condition").val!} 可用，最多可同时使用 #{$("._multiple-use").val!} 张。")
		_distribute-coupon-dom.change !->
			if Number($(@).val!) is 0
				console.log "11", 11
			else if Number($(@).val!) is 1
				console.log "22", 22
		_max-own-select-dom.change !->
			if Number($(@).val!) is 0
				console.log "11", 11
			else if Number($(@).val!) is 1
				console.log "22", 22
		_max-own-dom.keyup !->
			$(".tip-2-content").html("2. 每个微信号限领取 #{$("._max-own").val!} 张代金券；")
		_multiple-use-dom.keyup !->
			$(".tip-3-content").html("3. 订单消费满 ￥#{$("._use-condition").val!} 可用，最多可同时使用 #{$("._multiple-use").val!} 张。")
		_date-period-start-dom.change !->
			$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")
		_date-period-end-dom.change !->
			$("._date-period-tip").html("有效期：#{_date-period-start-dom.val!} 至 #{_date-period-end-dom.val!}")

	time-out-id = ''
	show-global-message = (str)->
		ob = $ '#global_message'
		ob.show!
		ob.html str
		clearTimeout time-out-id
		time-out-id := setTimeout('$("#global_message").fadeOut(300)',2000)

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"


	initial: !->
		_init-all-coupon!
		_init-coupon-view!
		_init-depend-module!
		_init-all-event!
		_init-all-keyup!

 
module.exports = main-manage