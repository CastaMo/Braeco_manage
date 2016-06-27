require_ 									= require "./requireManage.js"

PageView 									= require "./View/PageView.js"
SubitemMainView 					= require "./View/SubitemMainView.js"
SubitemModifyView 				= require "./View/SubitemModifyView.js"

PageController 						= require "./Controller/PageController.js"
SubitemMainController 		= require "./Controller/SubitemMainController.js"
SubitemModifyController 	= require "./Controller/SubitemModifyController.js"

PageModel									= require "./Model/PageModel.js"
DishModel 								= require "./Model/DishModel.js"
SubitemModel 							= require "./Model/SubitemModel.js"
SubitemModifyModel 				= require "./Model/SubitemModifyModel.js"


let win = window, doc = document
	
	page-controller = null

	_init-callback = {
		"success" 			: 		(result)!-> _init-all-module result.data
	}

	_init-all-module = (data)!->
		console.log data
		require_.initial!

		subitem-model = new SubitemModel {
			datas 											: 			data.groups
		}
		dish-model 		= new DishModel {
			datas 											: 			data.categories
		}
		subitem-modify-model = new SubitemModifyModel {
			datas 											: 			data.categories
		}

		subitem-main-controller = new SubitemMainController {
			subitem-model 							: 			subitem-model
		}
		subitem-modify-controller = new SubitemModifyController {
			dish-model 									: 			dish-model
			subitem-model 							: 			subitem-model
			subitem-modify-model 				: 			subitem-modify-model
		}

		subitem-main-view = new SubitemMainView {
			subitem-main-controller 		: 		subitem-main-controller
			subitem-modify-controller 	: 		subitem-modify-controller
			subitem-model 							: 		subitem-model
			page-controller 						: 		page-controller
			el-CSS-selector 						: 		"\#subitem-main"
		}
		subitem-modify-view = new SubitemModifyView {
			page-controller 						: 		page-controller
			subitem-modify-controller 	: 		subitem-modify-controller
			subitem-modify-model 				: 		subitem-modify-model
			el-CSS-selector 						: 		"\#subitem-modify"
		}

	_init-page = !->
		page-model = new PageModel {
			datas 			: 			{
				toggle 		:				["modify", "main"]
				cover 		: 			["copy", "move", "loading", "sort"]
			}
			all-default-states 	: 	{
				toggle-state 	: 	"main"
				cover-state 	: 	"exit"
			}
		}

		page-controller := new PageController {
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

