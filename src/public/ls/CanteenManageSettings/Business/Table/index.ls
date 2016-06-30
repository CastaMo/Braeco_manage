let win = window, doc = document
	[getJSON] = [util.getJSON]

	_get-JSON = null

	_main-init = (result)->
		_init-callback["success"]?(result)

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-get-JSON-func result
			_init-all-module!
	}
	_init-all-get-JSON-func = (data)->
		_get-JSON := data

	_init-all-module = !->
		page = require "./pageManage.js";			page.initial!
		main = require "./mainManage.js";		 	main.initial _get-JSON

	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init;

	_test-is-data-ready!