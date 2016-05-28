main-manage = let
	page = null
	jumpPage = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]

	_search-dom = $ "\.search-btn"
	_last-page-dom = $ "\.lastPage"
	_next-page-dom = $ "\.nextPage"
	_jump-dom = $ "\.jump-btn"
	_modify-btn-dom = $ "\.modify"
	_recharge-btn-dom = $ "\.recharge"


	_init-all-event = !->
		_search-dom.click !->
			_init-table!
		_last-page-dom.click !->

		_next-page-dom.click !->

		_jump-dom.click !->
			jumpPage = document.getElementById("jump-input").lastChild.value

		_modify-btn-dom.click !->
			page.cover-page "modify"

		_recharge-btn-dom.click !->
			page.cover-page "recharge"


	_init-table = !->
		_test = $("json-field").html!
		_json = document.getElementById("json-field").innerHTML
		console.log "_test", _test
		console.log "_json", _json
		_obj = JSON.parse(_json)
		_length = _obj.length
		/*$('#Info tr:eq(1) td:eq(0)').html(x_o)*/

	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_init-table!
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage