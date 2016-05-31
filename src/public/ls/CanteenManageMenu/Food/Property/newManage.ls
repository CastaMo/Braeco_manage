main 	= null
page 	= null
subItem = null

new-manage = let

	_new-dom 						= $ "\#property-new"
	_name-input-dom 				= _new-dom.find ".name-field input"
	_remark-input-dom 				= _new-dom.find ".remark-field input"
	_property-sub-item-list-dom 	= _new-dom.find "ul.content-list"
	_add-sub-item-btn-dom		 	= _new-dom.find ".add-btn"
	_cancel-btn-dom 				= _new-dom.find ".cancel-btn"
	_save-btn-dom 					= _new-dom.find ".save-btn"

	_name 				= null
	_remark 			= null

	_content 			= []

	_init-depend-module = !->
		main 		:= require "./mainManage.js"
		page 		:= require "./pageManage.js"
		subItem 	:= require "./subItemManage.js"

	_init-all-event = !->
		_cancel-btn-dom.click !-> _cancel-btn-click-event!

		_save-btn-dom.click !-> _save-btn-click-event!

		_add-sub-item-btn-dom.click !-> _add-sub-item-btn-click-event!

	_add-sub-item-btn-click-event = !->
		subItem.add-proprety-sub-item!

	_cancel-btn-click-event = !->
		page.toggle-page "main"
		_reset!

	_save-btn-click-event = !->
		page.toggle-page "main"
		_reset!


	_reset = !->
		subItem.reset!
		_name-input-dom.val ""
		_remark-input-dom.val ""
		_name 		:= null
		_remark 	:= null
		_content 	:= []


	initial: !->
		_init-depend-module!
		_init-all-event!

	toggle-callback: !->
		_reset!
		subItem.set-current-property-sub-item-dom-by-target {
			property-sub-item-list-dom 		: 	_property-sub-item-list-dom
		}

module.exports = new-manage