main-manage = let
	page = null
	jumpPage = null
	_search-dom = $ "\.search-btn"
	_last-page-dom = $ "\.lastPage"
	_next-page-dom = $ "\.nextPage"
	_jump-dom = $ "\.jump-btn"
	_modify-btn-dom = $ "\.modify"
	_recharge-btn-dom = $ "\.recharge"


	_init-all-event = !->
		_search-dom.click !->

		_last-page-dom.click !->

		_next-page-dom.click !->

		_jump-dom.click !->
			jumpPage = document.getElementById("jump-input").lastChild.value

		_modify-btn-dom.click !->
			page.cover-page "modify"
		_recharge-btn-dom.click !-> 
			page.cover-page "recharge"


	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage