require_ 							= require "./requireManage.js"

PageView 							= require "./View/PageView.js"

PageController 				= require "./Controller/PageController.js"

PageModel							= require "./Model/PageModel.js"


let win = window, doc = document
	

	_init-callback = {
		"success" 			: 		(result)!-> _init-all-module result.data
	}

	_init-all-module = (data)!->
		console.log data
		require_.initial!

	_init-page = !->
		page-model = new PageModel {
			datas 			: 			{
				toggle 		:				["new", "edit", "main"]
				cover 		: 			["copy", "move", "loading", "sort"]
			}
			all-default-states 	: 	{
				toggle-state 	: 	"main"
				cover-state 	: 	"exit"
			}
		}

		page-controller = new PageController {
			page-model 	: 			page-model
		}

		page-view = new PageView {
			page-model 			: 			page-model
			page-controller : 			page-controller
			full-cover-CSS-selector 		: 	"\#full-cover"
			all-default-states 					: 	[
				opt =
					view 				: 	"li\#Combo-sub-menu"
					class-name 	: 	"choose"
				opt = 
					view 				: 	"\#combo-nav li\#Subitem"
					class-name 	: 	"choose"
			]
		}



	_main-init = (result)->
		_init-callback[result.message]?(result)

	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init

	_init-page!
	_test-is-data-ready!

