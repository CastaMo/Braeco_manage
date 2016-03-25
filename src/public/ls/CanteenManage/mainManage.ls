page = null
main-manage = let
	_state = page._state
	_step1-dom = $ "\#step1Content"
	_step2-dom = $ "\#step2Content"
	_step3-dom = $ "\#step3Content"
	_next-dom = $ "\#nextBtn"
	_last-dom = $ "\#lastBtn"
	_fin-dom = $ "\#finBtn"

	_init-all-event = !->
		_step1-dom.click !->
			page.toggle-page "step1"
		_step2-dom.click !->
			page.toggle-page "step2"
		_step3-dom.click !->
			page.toggle-page "step3"
		_next-dom.click !->
			_state = _state+1
		_last-dom.click !->
			_state = _state-1

	_init-depend-module = !->
		page := require "./pageManage.js"

	main-manage: (main)->
		get-state: -> return _state

	initial: !->
		_init-all-event!
		_init-depend-module!
 
 module.exports = main-manage