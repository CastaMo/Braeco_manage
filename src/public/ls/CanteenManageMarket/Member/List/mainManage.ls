main-manage = let
	page = null
	jumpPage = null
	_length = ""
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	activityArr = $("")
	_members = []
	_search-dom = $ "\.search-btn"
	_last-page-dom = $ "\.lastPage"
	_next-page-dom = $ "\.nextPage"
	_jump-dom = $ "\.jump-btn"
	_table-title-dom = $ "\.table-title"
	_table-dom = $ "\#Info"
	_close-dom = $ "\.close-btn"
	_cancle-dom = $ "\.cancel-btn"
	_save-dom = $ "\.confirm-btn"

	_init-all-event = !->
		_search-dom.click !->

		_last-page-dom.click !->

		_next-page-dom.click !->

		_jump-dom.click !->
			jumpPage = document.getElementById("jump-input").lastChild.value

		_close-dom.click !->
			page.cover-page "exit"
			_init-table!

		_cancle-dom.click !->
			page.cover-page "exit"
			_init-table!

		_save-dom.click !->
			_length = _members.length
			_x = $('#_input1').val!
			console.log "_x", _x
			_y = $('.memberID').html!
			console.log "_y", _y
			_z = $('#_input2').val!
			console.log "_z", _z
			for i from 0 to _length-1 by 1
				if _members[i].id == _y and _x != ""
					_members[i].EXP = _x
				else if _members[i].id == _y and _z != ""
					console.log "111", 111
					_z = Number(_members[i].balance)+Number(_z)
					_z = Number(_z)
					_z = _z.toFixed(2)
					_members[i].balance = Number(_z)
			_update-members!
			_init-table!
			page.cover-page "exit"

	class Member
		(options)!->
			deep-copy options, @
			_members.push @

	_update-members = !->
		memberArrJSON = JSON.stringify(_members)
		$('#json-field').html = memberArrJSON
		console.log "memberArrJSON", memberArrJSON

	_init-arry = !->
		memberArrJSON = $('#json-field').html!
		activityArr = []
		activityArr = JSON.parse(memberArrJSON)
		for member in activityArr
			new Member(member)


	_init-table = !->
		$('#_input1').val("")
		$('#_input2').val("")
		console.log "_members", _members
		_length = _members.length
		$("._line").remove!
		for i from 0 to _length-1 by 1
			_new-dom = $ "<tr class='_line'>
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
			_new-dom.find("._id").html(_members[i].id)
			_new-dom.find("._phone").html(_members[i].phone)
			_new-dom.find("._nick").html(_members[i].nick)
			_new-dom.find("._level").html(_members[i].level)
			_new-dom.find("._exp").html(_members[i].EXP)
			_new-dom.find("._balance").html(_members[i].balance)
			_table-dom.last().append _new-dom
			_new-dom.find(".modify").click !->
				_now =	$(@).parent().parent()
				$(".modifyIntegral").html(_now.find("._exp").html!)
				$(".WechatName").html(_now.find("._nick").html!)
				$(".phoneNumber").html(_now.find("._phone").html!)
				$(".memberID").html(_now.find("._id").html!)
				$(".parent").html(_now.find("._balance").html!)
				page.cover-page "modify"
			_new-dom.find(".recharge").click !->
				_now =	$(@).parent().parent()
				$(".modifyIntegral").html(_now.find("._balance").html!)
				$(".WechatName").html(_now.find("._nick").html!)
				$(".phoneNumber").html(_now.find("._phone").html!)
				$(".memberID").html(_now.find("._id").html!)
				$(".parent").html(_now.find("._exp").html!)
				page.cover-page "recharge"


	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_init-arry!
		_init-table!
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage