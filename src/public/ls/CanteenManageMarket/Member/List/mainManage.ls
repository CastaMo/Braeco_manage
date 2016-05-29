main-manage = let
	page = null
	jumpPage = null
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	activityArr = $("")
	_members = []
	_search-dom = $ "\.search-btn"
	_last-page-dom = $ "\.lastPage"
	_next-page-dom = $ "\.nextPage"
	_jump-dom = $ "\.jump-btn"
	_table-title-dom = $ "\.table-title"
	_table-dom = $ "\#Info"


	_init-all-event = !->
		_search-dom.click !->
			_init-table!
		_last-page-dom.click !->

		_next-page-dom.click !->

		_jump-dom.click !->
			jumpPage = document.getElementById("jump-input").lastChild.value

	class Member
		(options)!->
			deep-copy options, @
			_members.push @

	_init-table = !->
		memberArrJSON = $('#json-field').html!
		activityArr = JSON.parse(memberArrJSON);
		for member in activityArr
			new Member(member)
			console.log "member", member
		console.log "_members[0].id", _members[0].id
		console.log "_members", _members
		console.log "activityArr[0].id", activityArr[0].id
		_length = activityArr.length
		for i from 0 to _length-1 by 1
			_new-dom = $ "<tr>
							<td class='_id'></td>
							<td class='_phone'></td>
							<td class='_nick'></td>
							<td class='_level'></td>
							<td class='_exp'></td>
							<td class='_balance'></td>
							<td>
								<div class='modify btn'>
									<div class='modify-btn-image'></div>
									<p>修改积分</p>
								</div>
								<div class='recharge btn'>
									<div class='recharge-btn-image'></div>
									<p>充值</p>
								</div>
							</td>
						</tr>"
			_new-dom.find(".modify").click !->
				page.cover-page "modify"
			_new-dom.find(".recharge").click !->
				page.cover-page "recharge"
			_new-dom.find("._id").html(_members[i].id)
			_new-dom.find("._phone").html(_members[i].phone)
			_new-dom.find("._nick").html(_members[i].nick)
			_new-dom.find("._level").html(_members[i].level)
			_new-dom.find("._exp").html(_members[i].EXP)
			_new-dom.find("._balance").html(_members[i].balance + "元")
			_table-dom.last().append _new-dom

	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_init-table!
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage