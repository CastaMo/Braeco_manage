let win = window, doc = document

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-module()
	}

	_main-init = (result)->
		_init-callback["success"]?(result)

	_init-all-module = !->
		page = require "./pageManage.js";			page.initial!
		main = require "./mainManage.js";		 	main.initial!
		edit = require "./editManage.js";           edit.initial!


	_main-init!
