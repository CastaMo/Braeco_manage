page-manage = let
	_state = null

	$("\#Food-sub-menu").addClass "choose"
	$("\#food-nav li\#Single").addClass "choose"

	_main-dom = $ "\#food-single-main"
	_new-dom = $ "\#food-single-new"
	_edit-dom = $ "\#food-single-edit"
	_all-dom = [_main-dom, _new-dom, _edit-dom]

	_unshow-all-dom-except-given = (dom_)->
		for dom in _all-dom when dom isnt dom_
			dom.fade-out 200

	_toggle-page-callback = {
		"main"		:	 let
			->
				_main-dom.fade-in 200
				_unshow-all-dom-except-given _main-dom
		"new"		:	 let
			->
				_new-dom.fade-in 200
				_unshow-all-dom-except-given _new-dom

		"edit"		:	 let
			->
				_edit-dom.fade-in 200
				_unshow-all-dom-except-given _edit-dom
	}


	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage
