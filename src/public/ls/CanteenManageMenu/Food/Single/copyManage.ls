main = page = null
copy-manage = let
	[ 		deep-copy] = 
		[	util.deep-copy]

	_copy-dom 		= $ "\#full-cover .copy-field"
	_select-dom 	= _copy-dom.find "select"
	_close-dom 		= _copy-dom.find ".close-btn"
	_cancel-dom 	= _copy-dom.find ".cancel-btn"
	_save-dom 		= _copy-dom.find ".confirm-btn"


	_init-depend-module = !->
		main 		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"

	_init-all-event = !->
		_close-dom.click !-> page.cover-page "exit"

		_cancel-dom.click !-> page.cover-page "exit"

		_save-dom.click !-> _save-btn-click-event!

	_save-btn-click-event = !->
		if main.is-equal-for-category _select-dom.val! then alert "请选择其他品类"; return
		page.cover-page "exit"
		main.copy-for-current-choose-dishes-by-given _select-dom.val!

	initial: !->
		_init-depend-module!
		_init-all-event!

module.exports = copy-manage