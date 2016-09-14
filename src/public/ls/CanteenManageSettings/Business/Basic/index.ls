let win = window, doc = document
	[getJSON] = [util.getJSON]

	_get-business-JSON = null

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-get-JSON-func result.data
			_init-all-module result.url
	}

	_init-all-get-JSON-func = (data)->
		_get-business-JSON := -> return JSON.stringify(data)

	_main-init = (result)->
		_init-callback["success"]?(result)

	_init-all-module = (url)!->
		page = require "./pageManage.js";			page.initial!
		main = require "./mainManage.js";		 	main.initial _get-business-JSON, url
		edit = require "./editManage.js";           edit.initial!
	
	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init

	_test-is-data-ready!
