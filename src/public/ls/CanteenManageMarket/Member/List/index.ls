let win = window, doc = document

	_init-callback = {
		"Need to rescan qrcode" 	:	->	win.location.pathname = "/Table/Confirm/rescan"
		"success" 					:	(result)->
			_init-all-module(result)
	}

	_main-init = (result)->
		_init-callback["success"]?(result)

	_init-all-module = (result)!->
		page		= require "./pageManage.js";			page.initial!
		main		= require "./mainManage.js";		 	main.initial!
		modify		= require "./modifyManage.js";			modify.initial!
		recharge	= require "./rechargeManage.js";		recharge.initial!

	_main-init!
