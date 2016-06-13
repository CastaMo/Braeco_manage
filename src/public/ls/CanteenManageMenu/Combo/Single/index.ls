require_ 							= require "./requireManage.js"

PageView 							= require "./View/PageView.js"
CategorySelectView 		= require "./View/CategorySelectView.js"
ComboListView 				= require "./View/ComboListView.js"
HeaderView 						= require "./View/HeaderView.js"
NewView 							= require "./View/NewView.js"
EditView							= require "./View/EditView.js"


CategoryController 		= require "./Controller/CategoryController.js"
ComboController 			= require "./Controller/ComboController.js"
HeaderController 			= require "./Controller/HeaderController.js"
SubitemController 		= require "./Controller/SubitemController.js"
NewController 				= require "./Controller/NewController.js"
EditController				= require "./Controller/EditController.js"


let win = window, doc = document
	
	dc-type-map-dc-options = {
		"sale" 			: 			{
			min 		: 			1
			max 		:			50
			word 		: 			"元"
		}
		"discount" 		:			{
			min 		:			10
			max 		:			99
			word 		:			"%"
		}
		"limit" 		:			{
			min 		:			1
			max 		:			99
			word 		:			"份"
		}
	}

	_init-callback = {
		"success" 			: 		(result)!-> _init-all-module result.data
	}

	_init-all-module = (data)!->
		console.log data
		require_.initial!
		category-controller 	= new CategoryController opt 	=
			datas 								: 			data.categories
			all-default-states 		:				[ 				opt 			=
				default-category-id : 			data.categories[0].id
			]

		combo-controller 			= new ComboController opt 		=
			datas 								: 			data.categories

		subitem-controller 		= new SubitemController opt 	=
			datas 								: 			data.groups

		header-controller 		= new HeaderController opt 		=
			datas 								: 			["new", "edit", "move", "sort", "copy", "able", "remove"]
			all-default-states 		: 			[ 				opt 			=
				current-combo-ids 	: 			[]
				current-combo-ables : 			[]
			]

		new-controller 				= new NewController opt 			=
			dc-type-map-dc-options: 			dc-type-map-dc-options

		edit-controller 			= new EditController opt 			=
			dc-type-map-dc-options: 			dc-type-map-dc-options

		default-category-id = category-controller.get-current-category-id!

		category-select-view 	= new CategorySelectView opt 	=
			category-controller 	: 			category-controller
			el-CSS-selector 			: 			"select.category-select"


		combo-list-view 			= new ComboListView opt 			=
			combo-controller 			: 			combo-controller
			category-controller 	: 			category-controller
			subitem-controller 		: 			subitem-controller
			el-CSS-selector 			: 			"div.combo-list"
			all-default-states 		:				[ 				opt 			=
				default-category-id : 			default-category-id
			]

		header-view 					= new HeaderView opt 					=
			category-controller 	: 			category-controller
			combo-controller 			: 			combo-controller
			header-controller 		: 			header-controller
			new-controller 				: 			new-controller
			edit-controller 			: 			edit-controller
			el-CSS-selector 			: 			"div.combo-oper"
			all-default-states 		: 			[ 				opt 			=
				[
					{
						name 							: 			"new"
						able 							: 			true
					}
					{
						name 							: 			"edit"
						able 							: 			false
					}
					{
						name 							: 			"move"
						able 							: 			false
					}
					{
						name 							: 			"sort"
						able 							: 			true
					}
					{
						name 							: 			"copy"
						able 							: 			false
					}
					{
						name 							: 			"able"
						able 							: 			false
					}
					{
						name 							: 			"remove"
						able 							: 			false
					}
					
				]
			]

		new-view 							= new NewView opt 						=
			el-CSS-selector 			: 			"div\#combo-new"
			category-controller 	: 			category-controller
			subitem-controller 		: 			subitem-controller
			new-controller 				: 			new-controller
			dc-type-map-dc-options: 			dc-type-map-dc-options

		edit-view 						= new EditView opt 						=
			el-CSS-selector 			: 			"div\#combo-edit"
			category-controller 	: 			category-controller
			subitem-controller 		: 			subitem-controller
			edit-controller 			: 			edit-controller
			dc-type-map-dc-options: 			dc-type-map-dc-options

	_init-page = !->
		page-view = new PageView opt = 
			datas 					:
				toggle 				: 	["new", "edit", "main"]
				cover 				: 	["copy", "move"]

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

