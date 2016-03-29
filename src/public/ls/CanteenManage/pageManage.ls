page-manage = let
	main = null
	_state = null
	$(".config-menu-header").addClass "choose"

	_step1-dom = $ "\#step1Content"
	_step2-dom = $ "\#step2Content"
	_step3-dom = $ "\#step3Content"
	_step1-dom-btn = $ "\#step1"
	_step2-dom-btn = $ "\#step2"
	_step3-dom-btn = $ "\#step3"
	_next-dom = $ "\.nextBtn"
	_last-dom = $ "\.lastBtn"
	_fin-dom = $ "\.finBtn"

	_toggle-page-callback = {
		"step1"		:	 let
			->
				_state := 0
				_step2-dom.fade-out 200
				_step3-dom.fade-out 200
				_last-dom.fade-out 200
				_fin-dom.fade-out 200, ->
					_next-dom.fade-in 200
					_step1-dom.fade-in 200
				_step1-dom-btn.find(".rectangle").css {"background-color":"#0066CC"}
				_step1-dom-btn.find(".rectangle").css {"color":"white"}
				_step1-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent #0066CC"}
				_step1-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #797979"}
				_step2-dom-btn.find(".rectangle").css {"background-color":"white"}
				_step2-dom-btn.find(".rectangle").css {"color":"#333333"}
				_step2-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent white"}
				_step2-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #797979"}
				_step3-dom-btn.find(".rectangle").css {"background-color":"white"}
				_step3-dom-btn.find(".rectangle").css {"color":"#333333"}
		"step2"		:	 let
			->
				_state := 1
				_step1-dom.fade-out 200
				_fin-dom.fade-out 200
				_step3-dom.fade-out 200, ->
					_step2-dom.fade-in 200
					_next-dom.fade-in 200
					_last-dom.fade-in 200
				_step1-dom-btn.find(".rectangle").css {"background-color":"white"}
				_step1-dom-btn.find(".rectangle").css {"color":"#333333"}
				_step1-dom-btn.find(".triangle_border_right span").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_step1-dom-btn.find(".triangle_border_right").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_step2-dom-btn.find(".rectangle").css {"background-color":"#0066CC"}
				_step2-dom-btn.find(".rectangle").css {"color":"white"}
				_step2-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent #0066CC"}
				_step2-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #0066CC"}
				_step3-dom-btn.find(".rectangle").css {"background-color":"white"}
				_step3-dom-btn.find(".rectangle").css {"color":"#333333"}

		"step3"		:	 let
			->
				_state := 2
				_step1-dom.fade-out 200
				_step2-dom.fade-out 200
				_next-dom.fade-out 200, ->
					_step3-dom.fade-in 200
					_last-dom.fade-in 200
					_fin-dom.fade-in 200
				_step1-dom-btn.find(".rectangle").css {"background-color":"white"}
				_step1-dom-btn.find(".rectangle").css {"color":"#333333"}
				_step1-dom-btn.find(".triangle_border_right span").css {"border-color":"transparent transparent transparent white"}
				_step1-dom-btn.find(".triangle_border_right").css {"border-color":"transparent transparent transparent #797979"}
				_step2-dom-btn.find(".rectangle").css {"background-color":"white"}
				_step2-dom-btn.find(".rectangle").css {"color":"#333333"}
				_step2-dom-btn.find(".triangle_border_right span").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_step2-dom-btn.find(".triangle_border_right").css {"border-color":"#0066CC #0066CC #0066CC transparent"}
				_step3-dom-btn.find(".rectangle").css {"background-color":"#0066CC"}
				_step3-dom-btn.find(".rectangle").css {"color":"white"}
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