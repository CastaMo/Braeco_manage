page-manage = let
	main = null
	$("\#Card-sub-menu").addClass "choose"
	$("\#Coupon-sub-menu").addClass "choose"
	$("\#Coupon-nav li\#Basic").addClass "choose"
	_init-depend-module = !->
		main := require "./mainManage.js"

	_new-dom = $ "\#newCoupon"
	_detail-dom = $ "\#detailCoupon"
	_basic-dom = $ "\#Coupon"
	_all-dom = [_new-dom, _detail-dom, _basic-dom]

	_unshow-all-dom = !->
		for dom in _all-dom
			dom.fade-out 100

	_toggle-page-callback = {
		"basic"			:		let
			->
				_unshow-all-dom!
				_basic-dom.fade-in 100
		"new"			:		let
			->
				_unshow-all-dom!
				_new-dom.fade-in 100
		"detail"		:		let
			->
				_unshow-all-dom!
				_detail-dom.fade-in 100
	}

	initial: ->
		_init-depend-module!

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage