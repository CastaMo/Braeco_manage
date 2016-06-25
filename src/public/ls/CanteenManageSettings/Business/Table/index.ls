let win = window, doc = document
	_get-JSON = null

	_init-all-get-JSON-func = (data)->
		_get-JSON 		:= -> return data

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-get-JSON-func result.data
			_init-all-module()
	}

	_main-init = (result)->
		_init-callback["success"]?(result)

	_init-all-module = !->
		page = require "./pageManage.js";			page.initial!
		main = require "./mainManage.js";		 	main.initial!


	_main-init!
