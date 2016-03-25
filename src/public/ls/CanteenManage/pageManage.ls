page-manage = let
	_state = 0

	$(".config-menu-header").addClass "choose"

	switch(_state) {
		case 0:
			_step1-dom.show();
		break;
		case 1:
			_step2-dom.show();
		break;
		default:
			_step3-dom.show();
	}


	_step1-dom = $ "\#stepContent1, \#nextBtn"
	_step2-dom = $ "\#stepContent2, \#nextBtn, \#lastBtn"
	_step3-dom = $ "\#stepContent3, \#lastBtn, \#finBtn"
	_all-dom = [_step1-dom, _step2-dom, _step3-dom]



	_unshow-all-dom-except-given = (dom_)->
		for dom in _all-dom when dom isnt dom_
			dom.fade-out 200

	_toggle-page-callback = {
		"step1"		:	 let
			->
				_step1-dom.fade-in 200
				_unshow-all-dom-except-given _step1-dom
		"step2"		:	 let
			->
				_step2-dom.fade-in 200
				_unshow-all-dom-except-given _step2-dom

		"step3"		:	 let
			->
				_step3-dom.fade-in 200
				_unshow-all-dom-except-given _step3-dom
	}
	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage