page-manage = let
	_state = null

	$("\#Food-sub-menu").addClass "choose"
	$("\#food-nav li\#Single").addClass "choose"

	_main-dom 			= $ "\#food-single-main"
	_new-dom 			= $ "\#food-single-new"
	_edit-dom 			= $ "\#food-single-edit"
	_all-toggle-dom 	= [_main-dom, _new-dom, _edit-dom]

	_full-cover-dom 	= $ "\#full-cover"
	_move-dom 			= $ _full-cover-dom.find ".move-field"
	_copy-dom 			= $ _full-cover-dom.find ".copy-field"
	_all-cover-dom 		= [_move-dom, _copy-dom]
	

	_unshow-all-toggle-dom-except-given = (dom_)->
		for dom in _all-toggle-dom when dom isnt dom_
			dom.fade-out 200

	_unshow-all-cover-dom = !->
		for dom in _all-cover-dom
			dom.add-class "hide"

	_toggle-page-callback = {
		"main"		: 		let
			->
				_main-dom.fade-in 200
				_unshow-all-toggle-dom-except-given _main-dom
		"new"		: 		let
			->
				_new-dom.fade-in 200
				_unshow-all-toggle-dom-except-given _new-dom

		"edit"		: 		let
			->
				_edit-dom.fade-in 200
				_unshow-all-toggle-dom-except-given _edit-dom
	}

	_cover-page-callback = {
		"move" 		:		let
			->
				_unshow-all-cover-dom!
				_move-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
		"copy" 		:		let
			->
				_unshow-all-cover-dom!
				_copy-dom.remove-class "hide"
				_full-cover-dom.fade-in 100
		"exit" 		:		let
			->
				_full-cover-dom.fade-out 100, !-> _unshow-all-cover-dom!

	}

	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

	cover-page: (page)->
		_cover-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage
