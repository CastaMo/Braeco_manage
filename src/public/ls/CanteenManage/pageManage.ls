page-manage = let
	main = null
	_state = null
	$(".config-menu-header").addClass "choose"

	_step1-dom = $ "\#step1Content"
	_step2-dom = $ "\#step2Content"
	_step3-dom = $ "\#step3Content"
	_all-step-dom = [_step1-dom, _step2-dom, _step3-dom]
	_step1-dom-btn = $ "\#step1"
	_step2-dom-btn = $ "\#step2"
	_step3-dom-btn = $ "\#step3"
	_next-dom = $ "\.nextBtn"
	_last-dom = $ "\.lastBtn"
	_fin-dom = $ "\.finBtn"
	_all-btn-dom = [_last-dom, _next-dom, _fin-dom]

	_hide-all-dom = (dom_, callback)->
		for dom, i in dom_
			if i is dom_.length-1
				dom.fade-out 100, callback
			else dom.fade-out 100

	_rectangle-hide = (dom_)->
		dom_.find(".rectangle").css {"background-color":"white"}
		dom_.find(".rectangle").css {"color":"#333333"}

	_rectangle-show = (dom_)->
		dom_.find(".rectangle").css {"background-color":"#0066CC"}
		dom_.find(".rectangle").css {"color":"white"}

	_toggle-page-callback = {
		"step1"		:	 let
			->
				_state := 0
				_hide-all-dom _all-btn-dom
				_hide-all-dom _all-step-dom, ->
					_step1-dom.fade-in 200
					_next-dom.fade-in 200
				_rectangle-show _step1-dom-btn
				_step1-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent #0066CC"}
				_step1-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #797979"}
				_rectangle-hide _step2-dom-btn
				_step2-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent white"}
				_step2-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #797979"}
				_rectangle-hide _step3-dom-btn
				
		"step2"		:	 let
			->
				_state := 1
				_hide-all-dom _all-btn-dom
				_hide-all-dom _all-step-dom, ->
					_step2-dom.fade-in 200
					_next-dom.fade-in 200
					_last-dom.fade-in 200
				_rectangle-hide _step1-dom-btn
				_step1-dom-btn.find(".triangle_border_right span").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_step1-dom-btn.find(".triangle_border_right").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_rectangle-show _step2-dom-btn
				_step2-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent #0066CC"}
				_step2-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #0066CC"}
				_rectangle-hide _step3-dom-btn

		"step3"		:	 let
			->
				_state := 2
				_hide-all-dom _all-btn-dom
				_hide-all-dom _all-step-dom, ->
					_step3-dom.fade-in 200
					_last-dom.fade-in 200
					_fin-dom.fade-in 200
				_rectangle-hide _step1-dom-btn
				_step1-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent white"}
				_step1-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #797979"}
				_rectangle-hide _step2-dom-btn
				_step2-dom-btn.find(".triangle_border_right span").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_step2-dom-btn.find(".triangle_border_right").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_rectangle-show _step3-dom-btn
	}

	_init-depend-module = !->
		main := require "./mainManage.js"

	initial: ->
		_init-depend-module!
		_state := main.get-state!

	get-state: -> return _state

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage