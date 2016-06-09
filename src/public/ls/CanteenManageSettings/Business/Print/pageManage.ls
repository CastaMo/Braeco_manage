page-manage = let
	$("\#Business-sub-menu").addClass "choose"
	$("\#Business-nav li\#Print").addClass "choose"

	_basic-dom = $ "\#preview-field"
	_modify-dom = $ "\#modify-field"

	_toggle-page-callback = {
		"basic"			:		let
			->
				_modify-dom.fade-out 100
				_basic-dom.fade-in 100
		"modify"		:		let
			->
				_basic-dom.fade-out 100
				_modify-dom.fade-in 100
	}

	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage
