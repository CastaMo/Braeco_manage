main-manage = let
	page = null
	window["_ladder"] = []
	charge_ladder = []
	cashEXP = ""
	_level-modify-btn-dom = $ "\#level-modify-btn"
	_recharge-modify-btn-dom = $ "\#recharge-modify-btn"
	_cancel-btn-dom = $ "\.canBtn"
	_finish-btn-dom = $ "\.finBtn"

	_init-arry = !->
		allJSON = $('#json-field').html!
		all = {}
		all = JSON.parse(allJSON)
		_ladder = all['ladder']
		charge_ladder = all['charge_ladder']
		cashEXP = all['cashEXP']
		console.log "all", all
		console.log "_ladder", _ladder
		console.log "_ladder[0]", _ladder[0]
		console.log "_ladder[0].name", _ladder[0].name

	_init-table = !->
		for i from 0 to 5 by 1
			$("\#level-table tr").eq(i).children("td").eq(0).html(_ladder[0].name)
			$("\#level-table tr").eq(i).children("td").eq(1).html(_ladder[0].EXP)
			$("\#level-table tr").eq(i).children("td").eq(2).html("#{_ladder[0].discount}%")

	_init-all-event = !->
		_level-modify-btn-dom.click !->
			page.toggle-page "modify-level"
		_recharge-modify-btn-dom.click !->
			page.toggle-page "modify-recharge"
		_cancel-btn-dom.click !->
			page.toggle-page "basic"
		_finish-btn-dom.click !->
			page.toggle-page "basic"
	_init-depend-module = !->
		page := require "./pageManage.js"


	initial: !->
		_init-arry!
		_init-table!
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage