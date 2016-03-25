page-manage = let
	_state = main._state

	$(".config-menu-header").addClass "choose"

	_step1-dom = $ "\#step1Content, \#nextBtn"
	_step2-dom = $ "\#step2Content, \#nextBtn, \#lastBtn"
	_step3-dom = $ "\#step3Content, \#lastBtn, \#finBtn"
	_all-dom = [_step1-dom, _step2-dom, _step3-dom]

	_judge-to-show = ->
		switch _state
		case 0 then _step1-dom.fade-in 200
		case 1 then _step2-dom.fade-in 200
		case 2 then _step3-dom.fade-in 200
		default _step3-dom.fade-in 200

	_unshow-all-dom-except-given = (dom_)->
		for dom in _all-dom when dom isnt dom_
			dom.fade-out 200

	_toggle-page-callback = {
		"step1"		:	 let
			->
				_state = 0
				_judge-to-show!
				_unshow-all-dom-except-given _step1-dom
		"step2"		:	 let
			->
				_state = 1
				_judge-to-show!
				_unshow-all-dom-except-given _step2-dom

		"step3"		:	 let
			->
				_state = 2
				_judge-to-show!
				_unshow-all-dom-except-given _step3-dom
	}

	_init-depend-module = !->
		main := require "./mainManage.js"

	initial: ->
	_init-depend-module!
	_judge-to-show!
	toggle-page: (page)->
		get-state: -> return _state
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage