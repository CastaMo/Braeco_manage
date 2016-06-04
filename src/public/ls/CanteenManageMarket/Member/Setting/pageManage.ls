page-manage = let
	main = null
	$("\#Discount-sub-menu").addClass "choose"
	$("\#Member-sub-menu").addClass "choose"
	$("\#Member-nav li\#Setting").addClass "choose"
	_init-depend-module = !->
		main := require "./mainManage.js"

	_level-dom = $ "\#level"
	_recharge-dom = $ "\#recharge"
	_modify-level-dom = $ "\#modify-level"
	_modify-recharge-dom = $ "\#modify-recharge"
	_all-dom = [_level-dom, _recharge-dom, _modify-level-dom, _modify-recharge-dom]

	_unshow-all-dom = !->
		for dom in _all-dom
			dom.fade-out 100

	_toggle-page-callback = {
		"basic"			:		let
			->
				_unshow-all-dom!
				_level-dom.fade-in 100
				_recharge-dom.fade-in 100
		"modify-level"			:		let
			->
				_unshow-all-dom!
				_modify-level-dom.fade-in 100
		"modify-recharge"		:		let
			->
				_unshow-all-dom!
				_modify-recharge-dom.fade-in 100
	}

	initial: ->
		_init-depend-module!

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage