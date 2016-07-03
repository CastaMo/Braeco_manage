main-manage = let
	page = require_ = null
	jumpPage = null
	_isSearchValid = 0
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
	_modify-save-dom = $ "\.modify-field .confirm-btn"
	_recharge-save-dom = $ "\.recharge-field .confirm-btn"
	_loop-id-dom = $ "\.table-title ._loop-id a"
	_loop-level-dom = $ "\.table-title ._loop-level a"
	_loop-exp-dom = $ "\.table-title ._loop-exp a"
	_loop-balance-dom = $ "\.table-title ._loop-balance a"
	
	_init-all-keyup = !->
		$("._searchInput").keyup !->
			if event.keyCode is 13 then _search-dom.trigger "click"

		$('#_input1').keyup !->
			if event.keyCode is 13 then _modify-save-dom.trigger "click"

		$('#_input2').keyup !->
			if event.keyCode is 13 then _recharge-save-dom.trigger "click"

		$('#_suppPhone').keyup !->
			if event.keyCode is 13 then _recharge-save-dom.trigger "click"

		$("._jump-input").keyup !->
			if event.keyCode is 13 then _jump-dom.trigger "click"
			if event.keyCode is 13 then _save-dom.trigger "click"

	_init-all-blur = !->
		$("._searchInput").blur !->
			if $('._searchInput').val() == '' or /^[0-9]\d*$/.test($('._searchInput').val())
				_isSearchValid := 0
			else
				_isSearchValid := 1
				$('._searchInput').val('')
				alert('搜索会员只能输入数字')
				return false
		
		$('#_input1').blur !->
			if $('#_input1').val() == '' or /^[0-9]\d*$/.test($('#_input1').val())
				return true
			else
				$('#_input1').val('')
				alert('修改积分只能为正整数')
				return false

		$('#_input2').blur !->
			if $('#_input2').val() == '' or /^\+?[1-9]\d*$/.test($('#_input2').val())
				return true
			else
				$('#_input2').val('')
				alert('充值金额只能为正整数')
				return false

		$("._suppPhone").blur !->
			if $('._suppPhone').val() == '' or /^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/.test($('._suppPhone').val())
				return true
			else
				$("._suppPhone").val('')
				alert('输入正确的手机号码')
				return false

		$("._jump-input").blur !->
			if $('._jump-input').val() == '' or /^[1-9]\d*$/.test($('._jump-input').val())
				return true
			else
				$('._jump-input').val('')
				alert('请输入正确页码')
				return false

	_init-all-event = !->
		_search-dom.click !->
			searchNum = $('._searchInput').val!
			searchNum = Number(searchNum)
			if _isSearchValid is 0
				location.href = "/Manage/Market/Member/List?search=#{searchNum}"		

		_last-page-dom.click !->
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if pageArr.pn > 1 then pageArr.pn--
			location.href = "/Manage/Market/Member/List?by=create_date&search=#{pageArr.search}&in=#{pageArr.in}&pn=" + pageArr.pn

		_next-page-dom.click !->
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if pageArr.pn < pageArr.sum_pages then pageArr.pn++
			location.href = "/Manage/Market/Member/List?by=create_date&search=#{pageArr.search}&in=#{pageArr.in}&pn=" + pageArr.pn

		_jump-dom.click !->
			jumpPage = $("._jump-input").val!
			pageArrJSON = $('#page-JSON-field').html!
			pageArr = JSON.parse(pageArrJSON)
			if jumpPage isnt ''
				if jumpPage >= 1 and jumpPage <= pageArr.sum_pages
					location.href = "/Manage/Market/Member/List?by=create_date&in=#{pageArr.in}&pn=" + jumpPage
				else alert('请输入正确页码')
			else alert('请输入正确页码')
		_close-dom.click !->
			page.cover-page "exit"
			_init-table!

		_cancle-dom.click !->
			page.cover-page "exit"
			_init-table!

		_modify-save-dom.click !->
			if $('#_input1').val() != ''
				if $('#_input1').val() > 1000000
					$('#_input1').val('')
					alert('请输入0-1000000的整数')
					return
				_length = _members.length
				modify-input = $('#_input1').val!
				parentID = $('.displayID').html!
				searchNum = $('._searchInput').val!
				request-object = {}
				request-object.exp = modify-input;
				require_.get("modify").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
						user-id :		parentID;
					}
					callback 	:		(succes)!-> alert('修改成功', true);setTimeout('location.reload()', 2000)
				}
			else alert('修改失败')

		_recharge-save-dom.click !->
			if $('#_input2').val() != ''
				if $('#_input2').val() > 10000
					$('#_input2').val('')
					alert('请输入1-10000的整数')
					return
				_length = _members.length
				parentID = $('.displayID').html!
				recharge-input = $('#_input2').val!
				searchNum = $('._searchInput').val!
				request-object = {}
				request-object.amount = recharge-input;
				if $(".phoneNumber").html! is "-"
					request-object.phone = $("._suppPhone").val!
				else
					request-object.phone = $(".phoneNumber").html!
				require_.get("recharge").require {
					data 		:		{
						JSON 	:		JSON.stringify(request-object)
						user-id :		parentID;
					}
					callback 	:		(succes)!-> alert('充值成功', true);setTimeout('location.reload()', 2000)
				}
			else alert('充值失败')

	class Member
		(options)!->
			deep-copy options, @
			_members.push @

	_update-members = !->
		memberArrJSON = JSON.stringify(_members)
		$('#json-field').html = memberArrJSON

	_init-arry = !->
		memberArrJSON = $('#json-field').html!
		activityArr = []
		activityArr = JSON.parse(memberArrJSON)
		for member in activityArr
			new Member(member)

	_init-table = !->
		$('#_input1').val("")
		$('#_input2').val("")
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
			_new-dom.find("._balance").html(_members[i].balance + "元")
			_table-dom.last().append _new-dom
			_new-dom.find(".modify").click !->
				_now =	$(@).parent().parent()
				$(".displayID").html(_now.find("._displayID").html!)
				$(".modifyIntegral").html(_now.find("._exp").html!)
				$(".WechatName").html(_now.find("._nick").html!)
				$(".phoneNumber").html(_now.find("._phone").html!)
				$(".memberID").html(_now.find("._id").html!)
				_reduce = _now.find("._balance").html!
				_reduce = _reduce.replace("元", "")
				$(".parent").html(_now.find("._balance").html!)
				page.cover-page "modify"
			_new-dom.find(".recharge").click !->
				_now =	$(@).parent().parent()
				$(".displayID").html(_now.find("._displayID").html!)
				_reduce = _now.find("._balance").html!
				_reduce = _reduce.replace("元", "")
				$(".modifyIntegral").html(_reduce)
				$(".WechatName").html(_now.find("._nick").html!)
				if _now.find("._phone").html! == "-"
					$(".preview-wrapper").removeClass "_hasphone"
					$(".preview-wrapper").addClass "_nophone"
				else
					$(".preview-wrapper").removeClass "_nophone"
					$(".preview-wrapper").addClass "_hasphone"
				$(".phoneNumber").html(_now.find("._phone").html!)
				$(".memberID").html(_now.find("._id").html!)
				$(".parent").html(_now.find("._exp").html!)
				page.cover-page "recharge"
		pageArrJSON = $('#page-JSON-field').html!
		pageArr = JSON.parse(pageArrJSON)
		if pageArr.search isnt null
			$("._searchInput").val("#{pageArr.search}")
		$(".page").html(pageArr.pn + "/" + pageArr.sum_pages)
		if pageArr.in is "DESC" then
			_loop-id-dom.attr("href", "?by=create_date&in=ASC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-level-dom.attr("href", "?by=EXP&in=ASC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-exp-dom.attr("href", "?by=EXP&in=ASC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-balance-dom.attr("href", "?by=balance&in=ASCC&search=#{pageArr.search}&pn=#{pageArr.pn}")
		else if pageArr.in is "ASC" then
			_loop-id-dom.attr("href", "?by=create_date&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-level-dom.attr("href", "?by=EXP&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-exp-dom.attr("href", "?by=EXP&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")
			_loop-balance-dom.attr("href", "?by=balance&in=DESC&search=#{pageArr.search}&pn=#{pageArr.pn}")

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ := require "./requireManage.js"

	initial: !->
		_init-all-blur!
		_init-all-keyup!
		_init-arry!
		_init-table!
		_init-depend-module!
		_init-all-event!

 
module.exports = main-manage