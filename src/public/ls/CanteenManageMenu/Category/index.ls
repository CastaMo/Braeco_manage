let win = window, doc = document
	[getJSON] = [util.getJSON]

	_get-category-JSON = null

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-get-JSON-func result.data
			_init-all-module()
	}

	_init-all-get-JSON-func = (data)->
		_get-category-JSON := -> return JSON.stringify(data.category)


	_main-init = (result)->
		_init-callback[result.message]?(result)

	_init-all-module = !->
		page = require "./pageManage.js";			page.initial!
		main = require "./mainManage.js";		 	main.initial _get-category-JSON
		new_ = require "./newManage.js"; 			new_.initial!
		edit = require "./editManage.js"; 			edit.initial!


	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init

	_test-is-data-ready!

