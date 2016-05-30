main-manage = let
	page = require_ = null
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
		$("._searchInput").keydown (event)!->
			if event.keyCode is 13 then _search-dom.trigger "click"
		_search-dom.click !->
			_location = "/Manage/Market/Member/List?search=" + $('._searchInput').val!
			console.log "_location", _location
			location.href = _location
		_last-page-dom.click !->
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if pageArr.pn > 1 then pageArr.pn--
			pageArrJSON = JSON.stringify(pageArr)
			$('#page-JSON-field').html(pageArrJSON)
			_init-table!
		_next-page-dom.click !->
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if pageArr.pn < pageArr.sum_pages then pageArr.pn++
			pageArrJSON = JSON.stringify(pageArr)
			$('#page-JSON-field').html(pageArrJSON)
			_init-table!
		_jump-dom.click !->
			jumpPage = $("._jump-input").val!
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if jumpPage >= 1 and jumpPage <= pageArr.sum_pages then pageArr.pn = jumpPage
			pageArrJSON = JSON.stringify(pageArr)
			$('#page-JSON-field').html(pageArrJSON)
			_init-table!
		_close-dom.click !->
			page.cover-page "exit"
			_init-table!

		_cancle-dom.click !->
			page.cover-page "exit"
			_init-table!

		_save-dom.click !->
			_length = _members.length
			modify-input = $('#_input1').val!
			console.log "modify-input", modify-input
			parentID = $('.displayID').html!
			console.log "parentID", parentID
			recharge-input = $('#_input2').val!
			console.log "recharge-input", recharge-input
			request-object = {}
			for i from 0 to _length-1 by 1
				if _members[i].id == parentID and modify-input != ""
					_members[i].EXP = modify-input
					request-object.exp = modify-input;
					require_.get("modify").require {
						data 		:		{
							JSON 	:		JSON.stringify(request-object)
							user-id :		parentID;
						}
						success 	:		(result)!->console.log result
					}
				else if _members[i].id == parentID and recharge-input != ""
					console.log "111", 111
					recharge-input = Number(_members[i].balance)+Number(recharge-input)
					recharge-input = Number(recharge-input)
					recharge-input = recharge-input.toFixed(2)
					_members[i].balance = Number(recharge-input)
					request-object.amount = recharge-input;
					request-object.phone = $(".phoneNumber").html!
					require_.get("modify").require {
						data 		:		{
							JSON 	:		JSON.stringify(request-object)
							user-id :		parentID;
						}
						success 	:		(result)!->console.log result
					}
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
							<td class='_displayID'></td>
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
			_new-dom.find("._displayID").html(_members[i].id)
			_new-dom.find("._id").html(_members[i].id_of_dinner)
			_new-dom.find("._phone").html(_members[i].phone)
			_new-dom.find("._nick").html(_members[i].nick)
			_new-dom.find("._level").html(_members[i].level)
			_new-dom.find("._exp").html(_members[i].EXP)
			_new-dom.find("._balance").html(_members[i].balance)
			_table-dom.last().append _new-dom
			_new-dom.find(".modify").click !->
				_now =	$(@).parent().parent()
				$(".displayID").html(_now.find("._displayID").html!)
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
		pageArrJSON = $('#page-JSON-field').html!
		pageArr = JSON.parse(pageArrJSON)
		console.log "pageArr", pageArr
		$(".page").html(pageArr.pn + "/" + pageArr.sum_pages)


	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"

	initial: !->
		_init-arry!
		_init-table!
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage