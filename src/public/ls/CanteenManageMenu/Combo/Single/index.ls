PageView 							= require "./View/PageView.js"
CategorySelectView 		= require "./View/CategorySelectView.js"
ComboListView 				= require "./View/ComboListView.js"


CategoryController 		= require "./Controller/CategoryController.js"
ComboController 			= require "./Controller/ComboController.js"


let win = window, doc = document
	
	_init-callback = {
		"success" 			: 		(result)!-> _init-all-module result.data
	}

	_init-all-module = (data)!->
		console.log data
		category-controller 	= new CategoryController opt 	=
			datas 								: 			data.categories

		category-select-view 	= new CategorySelectView opt 	=
			category-controller 	: 			category-controller
			el-CSS-selector 			: 			"select.category-select"

		combo-controller 			= new ComboController opt 		=
			datas 								: 			data.categories
		console.log combo-controller, category-controller
		combo-list-view 			= new ComboListView opt 			=
			combo-controller 			: 			combo-controller
			category-controller 	: 			category-controller
			el-CSS-selector 			: 			"div.combo-list"

	_init-page = !->
		pageview = new PageView opt = 
			all-default-states 	: 	[
				opt =
					view 				: 	"li\#Combo-sub-menu"
					class-name 	: 	"choose"
				opt = 
					view 				: 	"\#combo-nav li\#Single"
					class-name 	: 	"choose"
			]


	_main-init = (result)->
		_init-callback[result.message]?(result)

	_test-is-data-ready = ->
		if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
		else window.main-init = _main-init

	_init-page!
	_test-is-data-ready!

