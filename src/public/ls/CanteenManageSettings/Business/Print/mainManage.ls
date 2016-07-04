main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = require_ = null
	printer = []
	categories = []
	tables = []
	ban = []
	ban_cat = []
	ban_table = []
	_remark-dom = $ "\._printRemark"
	_cancel-btn-dom = $ "\.cancel-btn"
	_save-btn-dom = $ "\.save-btn"
	_printCut-dom = $ "\._printCut"
	_test-dom = $ "\.test-btn"
	_confirm-btn-dom = $ "\.stop-confirm-btn"
	_confirm-cancel-btn-dom = $ "\.stop-confirm-cancel-btn"
	_modify-confirm-btn-dom = $ "\#modify-btn-field .confirm-btn"
	_modify-confirm-cancel-btn-dom = $ "\#modify-btn-field .confirm-cancel-btn"

	_init-JSON = (_get-JSON)!->
		all = get-JSON _get-JSON!
		printer := all['printer']
		categories := all['categories']
		tables := all['tables']
		console.log "all", all

	_init-table = !->
		$("html, body").animate({ scrollTop: 0 }, "fast");
		console.log "printer", printer
		console.log "categories", categories
		console.log "tables", tables
		for i from 0 to printer.length-1 by 1
			_new-printer = $ "<div class = 'printer-sin'>
								<div class = 'printer-single'>
									<div class = 'printer-single-hover'>
										<div class = 'single-hover'>
											<p>停用中</p>
										</div>
									</div>
									<div class = 'printerID content-set'></div>
									<div class = 'printerRemark content-set'></div>
									<div class = 'printerSeparate content-set'></div>
									<div class = 'printerPage content-set'></div>
									<div class = 'printerSize content-set'></div>
									<div class = 'setting content-set'>
										<div class = 'setting-btn btn'>
											<div class = 'setting-icon'></div>
											<p>设置</p>
										</div>
										<div class = 'switch-btn btn'>
											<div class = 'switch-icon'></div>
											<p></p>
										</div>
										<div class = 'stop-confirm stop-confirm-image'>
											<p>确认停用该打印机吗？</p>
											<div id = 'stop-confirm-btn-field'>
												<div class = 'stop-confirm-btn btn'>
													<p>确认</>
												</div>
												<div class = 'stop-confirm-cancel-btn btn'>
													<p>取消</>
												</div>
											</div>
										</div>
									</div>
									<div class = 'clear'></div>
								</div>
								<div class = 'clear'></div>
							</div>"
			_new-printer.find(".printerID").html(printer[i].id)
			_new-printer.find(".printerRemark").html(printer[i].remark)
			if printer[i].separate is true
				_new-printer.find(".printerSeparate").html("是")
			else if printer[i].separate is false
				_new-printer.find(".printerSeparate").html("否")
			if printer[i].able is true
				_new-printer.find(".switch-icon").removeClass("able-icon")
				_new-printer.find(".switch-icon").addClass("unable-icon")
				_new-printer.find(".switch-btn p").html("停用")
				_new-printer.find(".single-hover").css("display", "none")
			else if printer[i].able is false
				_new-printer.find(".switch-icon").removeClass("unable-icon")
				_new-printer.find(".switch-icon").addClass("able-icon")
				_new-printer.find(".switch-btn p").html("启用")
				_new-printer.find(".single-hover").css("display", "block")
			_new-printer.find(".printerPage").html("#{printer[i].page}联")
			if printer[i].size is 0
				_new-printer.find(".printerSize").html("小")
			else if printer[i].size is 1
				_new-printer.find(".printerSize").html("大")
			$(".table-list").last().append _new-printer
			_new-printer.find(".switch-btn").click !->
				if $(@).find("p").html() is "停用"
					$(@).parent().find(".stop-confirm").fade-in 300
					$(".confirm-mask").fade-in 300
				else $(@).parent().find(".stop-confirm-btn").click!
			_new-printer.find(".stop-confirm-cancel-btn").click !->
				$(@).parent().parent().fade-out 300
				$(".confirm-mask").fade-out 300
			_new-printer.find(".stop-confirm-btn").click !->
				request-object = {}
				_hrefID = Number($(@).parent().parent().parent().parent().find(".printerID").html!)
				console.log "_hrefID", _hrefID
				if $(@).parent().parent().parent().parent().find(".switch-btn p").html() is "启用"
					_able = 1
				else if $(@).parent().parent().parent().parent().find(".switch-btn p").html() is "停用"
					_able = 0
				request-object.id = Number($(@).parent().parent().parent().parent().find(".printerID").html!)
				require_.get("able").require {
					data 			:		{
						JSON 		:		JSON.stringify(request-object)
						able 		:		_able
						printer-id 	:		_hrefID;
					}
					callback 		:		(result)!-> location.reload!
				}
			_new-printer.find(".setting-btn").click !->
				checkedBan = $(@).parent().parent().find(".printerID").html!
				console.log "checkedBan", checkedBan
				for n from 0 to printer.length-1 by 1
					if printer[n].id is Number(checkedBan)
						ban := printer[n]['ban']
						ban_cat := printer[n]['ban_cat']
						ban_table := printer[n]['ban_table']
				$('#categories-choose ._all input').click !->
					_apply = $(@).parent()
					if _apply.hasClass("true")
						$('#categories-choose .allChoose input').attr("checked", false)
						$('#categories-choose .allChoose input').parent().removeClass "true"
						$('#categories-choose .allChoose input').parent().addClass "false"
					else if _apply.hasClass("false")
						$('#categories-choose .allChoose input').attr("checked", true)
						$('#categories-choose .allChoose input').parent().removeClass "false"
						$('#categories-choose .allChoose input').parent().addClass "true"
				$('#tables-choose ._all input').click !->
					_apply = $(@).parent()
					if _apply.hasClass("true")
						$('#tables-choose .allChoose input').attr("checked", false)
						$('#tables-choose .allChoose input').parent().removeClass "true"
						$('#tables-choose .allChoose input').parent().addClass "false"
					else if _apply.hasClass("false")
						$('#categories-choose .allChoose input').attr("checked", true)
						$('#tables-choose .allChoose input').parent().removeClass "false"
						$('#tables-choose .allChoose input').parent().addClass "true"
				for i from 0 to printer.length-1 by 1
					if $(@).parent().parent().find(".printerID").html! is "#{printer[i].id}"
						$("._printID").html(printer[i].id)
						$("._printRemark").val(printer[i].remark)
						$("._printCut").val("#{printer[i].separate}")
						if printer[i].separate is true
							$("._printFont").css("background-color" , '#E7E7EB')
							$("._printUnit").css("background-color" , '#E7E7EB')
							$("._printFont").attr("disabled", true)
							$("._printUnit").attr("disabled", true)
						else if printer[i].separate is false
							$("._printFont").css("background-color" , '#FFFFFF')
							$("._printUnit").css("background-color" , '#FFFFFF')
							$("._printFont").attr("disabled", false)
							$("._printUnit").attr("disabled", false)
						$("._printUnit").val("#{printer[i].page}")
						$("._printFont").val("#{printer[i].size}")
						if categories.length > 0
							for j from 0 to categories.length-1 by 1
								_new-categories = $ "<li>
														<ul class = 'shown'>
															<li class = 'shown-item open'>
																<div class = 'open-icon'></div>
																<span class = '_name'></span>
																<div class = 'checkbox-icon true'>
																	<input class = 'checkInput' type = 'checkbox' checked = 'true'></input>
																</div>
															</li>
														</ul>
													</li>"
								_new-categories.find("._name").html(categories[j].name)
								_new-categories.find("._name").val(categories[j].id)
								_new-categories.find(".checkInput").click !->
									_apply = $(this).parent()
									if _apply.hasClass("true")
										_apply.parent().parent().find("input").attr("checked", false)
										_apply.parent().parent().find("input").parent().removeClass "true"
										_apply.parent().parent().find("input").parent().addClass "false"
										if $('#categories-choose ._all .checkbox-icon').hasClass("true")
											_checkNullSize = 0
											checkNullSize = $('.shown-item').length - 1
											for i from 0 to checkNullSize-1 by 1
												if $('#categories-choose').find(".shown-item").eq(i+1).find("input").parent().hasClass("true")
													_checkNullSize++
											if _checkNullSize is 0
													$('#categories-choose ._all .checkbox-icon input').attr("checked", false)
													$('#categories-choose ._all .checkbox-icon').removeClass "true"
													$('#categories-choose ._all .checkbox-icon').addClass "false"
									else if _apply.hasClass("false")
										_apply.parent().parent().find("input").attr("checked", true)
										_apply.parent().parent().find("input").parent().removeClass "false"
										_apply.parent().parent().find("input").parent().addClass "true"
										if $('#categories-choose ._all .checkbox-icon').hasClass("false")
											$('#categories-choose ._all .checkbox-icon input').attr("checked", true)
											$('#categories-choose ._all .checkbox-icon').removeClass "false"
											$('#categories-choose ._all .checkbox-icon').addClass "true"
								_new-categories.find(".shown-item").click !->
									if $(@).hasClass "open" and not $(event.target).hasClass "checkInput"
										$(@).removeClass "open"
										$(@).addClass "close"
										$(@).parent().find(".inner-shown-item").slide-up 300
									else if $(@).hasClass "close" and not $(event.target).hasClass "checkInput"
										$(@).removeClass "close"
										$(@).addClass "open"
										$(@).parent().find(".inner-shown-item").slide-down 300
								for k from 0 to categories[j].dishes.length-1 by 1
									_new-dish = $  "<li class = 'inner-shown-item'>
														<span class = 'dish_name'></span>
														<div class = 'checkbox-icon true'>
															<input type = 'checkbox' checked = 'true'></input>
														</div>
													</li>"
									_new-dish.find(".dish_name").html(categories[j].dishes[k].name)
									_new-dish.find(".dish_name").val(categories[j].dishes[k].id)
									if $.inArray(categories[j].dishes[k].id, ban) >= 0
										_new-dish.find("input").attr("checked", false)
										_new-dish.find("input").parent().removeClass "true"
										_new-dish.find("input").parent().addClass "false"
									_new-categories.find(".shown").last().append _new-dish
									_new-dish.find("input").click !->
										_apply = $(@).parent()
										if _apply.hasClass("true")
											$(@).attr("checked", false)
											_apply.removeClass "true"
											_apply.addClass "false"
										else if _apply.hasClass("false")
											$(@).attr("checked", true)
											_apply.removeClass "false"
											_apply.addClass "true"
											if $(@).parents(".shown").find(".checkInput").parent().hasClass("false")
												$('#categories-choose ._all input').attr("checked", true)
												$('#categories-choose ._all input').parent().removeClass "false"
												$('#categories-choose ._all input').parent().addClass "true"
												$(@).parents(".shown").find(".checkInput").attr("checked", true)
												$(@).parents(".shown").find(".checkInput").parent().removeClass "false"
												$(@).parents(".shown").find(".checkInput").parent().addClass "true"
								if $.inArray(categories[j].id, ban_cat) >= 0
									if $.inArray(categories[j].id, ban_cat) is categories.length-1
										$('#categories-choose ._all input').attr("checked", false)
										$('#categories-choose ._all input').parent().removeClass "true"
										$('#categories-choose ._all input').parent().addClass "false"
									_new-categories.find(".checkInput").attr("checked", false)
									_new-categories.find(".shown input").parent().removeClass "true"
									_new-categories.find(".shown input").parent().addClass "false"
								$('#printBranch .allChoose').last().append _new-categories
						for m from 0 to tables.length-1 by 1
							_new-tables = $ "<li>
												<ul class = 'shown'>
													<li class = 'inner-shown-item'>
														<span class = 'table_name'></span>
														<div class = 'checkbox-icon true'>
															<input type = 'checkbox' checked = 'true'></input>
														</div>
													</li>
												</ul>
											</li>"
							_new-tables.find(".table_name").html(tables[m])
							_new-tables.find("input").click !->
								_apply = $(@).parent()
								if _apply.hasClass("true")
									$(@).attr("checked", false)
									_apply.removeClass "true"
									_apply.addClass "false"
									if $('#tables-choose .shown-item .checkbox-icon').hasClass("true")
										_checkNullSize = 0
										checkNullSize = $('#tables-choose').find("li").length - 1
										for i from 0 to checkNullSize-1 by 1
											if $('#tables-choose').find(".allChoose li").eq(i+1).find("input").parent().hasClass("true")
												_checkNullSize++
										if _checkNullSize is 0
												$('#tables-choose').find(".shown-item .checkbox-icon input").attr("checked", false)
												$('#tables-choose').find(".shown-item .checkbox-icon").removeClass "true"
												$('#tables-choose').find(".shown-item .checkbox-icon").addClass "false"
								else if _apply.hasClass("false")
									$(@).attr("checked", true)
									_apply.removeClass "false"
									_apply.addClass "true"
									if $('#tables-choose').find(".shown-item .checkbox-icon").hasClass("false")
												$('#tables-choose').find(".shown-item .checkbox-icon input").attr("checked", true)
												$('#tables-choose').find(".shown-item .checkbox-icon").removeClass "false"
												$('#tables-choose').find(".shown-item .checkbox-icon").addClass "true"
							if $.inArray(tables[m], ban_table) >= 0
								_new-tables.find("input").attr("checked", false)
								_new-tables.find("input").parent().removeClass "true"
								_new-tables.find("input").parent().addClass "false"
							$('#tables-choose .allChoose').last().append _new-tables
				page.toggle-page "modify"

	_init-all-event = !->
		_remark-dom.blur !->
			str = _remark-dom.val!
			console.log "str", str
			chineses = str.match(/[\u4E00-\u9FA5\uF900-\uFA2D]/g)
			cn-len = if chineses then chineses.length else 0
			other-len = str.length - cn-len
			total = cn-len * 2 + other-len
			console.log "total", total
			change-total = 0
			change-str = ''
			if total > 24
				for i from 0 to 23
					if str[i].match(/[\u4E00-\u9FA5\uF900-\uFA2D]/g)
						change-total += 2
					else 
						change-total += 1
					if change-total > 24
						change-str
					else change-str += str[i]
				_remark-dom.val(change-str)

		_test-dom.click !->
			request-object = {}
			require_.get("test").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
				}
				callback 	:		(result)!-> location.reload!
			}

		_printCut-dom.change !->
			if $("._printCut").val() is "true"
				$("._printFont").val(1)
				$("._printUnit").val(1)
				$("._printFont").css("background-color" , '#E7E7EB')
				$("._printUnit").css("background-color" , '#E7E7EB')
				$("._printFont").attr("disabled", true)
				$("._printUnit").attr("disabled", true)
			else if $("._printCut").val() is "false"
				$("._printFont").css("background-color" , '#FFFFFF')
				$("._printUnit").css("background-color" , '#FFFFFF')
				$("._printFont").attr("disabled", false)
				$("._printUnit").attr("disabled", false)

		_cancel-btn-dom.click !->
			$('#modify-btn-field .stop-confirm').fade-in 100
			$('#modify-btn-field .confirm-mask').fade-in 100

		_modify-confirm-btn-dom.click !->
			$('#modify-btn-field .stop-confirm').fade-out 100
			$('#modify-btn-field .confirm-mask').fade-out 100

		_modify-confirm-cancel-btn-dom.click !->
			$('#modify-btn-field .stop-confirm').fade-out 100
			$('#modify-btn-field .confirm-mask').fade-out 100
			page.toggle-page "basic"

		_save-btn-dom.click !->
			_ban = []
			_ban-cat = []
			_ban-table = []
			for i from 0 to categories.length-1 by 1
				if $(".checkInput").eq(i).parent().hasClass("false")
					_search = $(".checkInput").eq(i).parent().parent().find("._name").html!
					_searchID =  $(".checkInput").eq(i).parent().parent().find("._name").val!
					_ban-cat.push(Number(_searchID))
					console.log "_ban-cat", _ban-cat
					console.log "_search", _search
				else if $(".checkInput").eq(i).parent().hasClass("true")
					_search = $(".checkInput").eq(i).parent().parent().find("._name").html!
					for k from 0 to categories.length-1 by 1
						if _search is categories[k].name
							for j from 0 to categories[k].dishes.length-1 by 1
								if $(".checkInput").eq(i).parents(".shown").find(".inner-shown-item").eq(j).find("input").parent().hasClass("false")
									_search =  $(".checkInput").eq(i).parents(".shown").find(".inner-shown-item").eq(j).find("input").parent().parent().find(".dish_name").html!
									_searchID = $(".checkInput").eq(i).parents(".shown").find(".inner-shown-item").eq(j).find("input").parent().parent().find(".dish_name").val!
									_ban.push(Number(_searchID))
									console.log "_ban", _ban
									console.log "_search", _search
			for i from 0 to tables.length-1 by 1
				if $('#tables-choose .inner-shown-item .checkbox-icon').eq(i).hasClass("false")
					_search = $('#tables-choose .inner-shown-item .checkbox-icon').eq(i).parent().find(".table_name").html!
					console.log "_search", _search
					_ban-table.push(_search)
					console.log "_ban-table", _ban-table
			request-object = {}
			request-object.page = Number($("._printUnit").val!)
			request-object.ban = _ban
			request-object.ban_cat = _ban-cat
			request-object.ban_table = _ban-table
			if $("._printCut").val() is "true"
				request-object.separate = true
			else if $("._printCut").val() is "false"
				request-object.separate = false
			request-object.remark = $("._printRemark").val!
			request-object.id = Number($("._printID").html!)
			request-object.size = Number($("._printFont").val!)
			console.log "request-object", request-object
			require_.get("modify").require {
				data 		:		{
					JSON 	:		JSON.stringify(request-object)
					printer-id:		Number($("._printID").html!)
				}
				callback 	:		(result)!-> alert('修改成功', true);setTimeout('location.reload()', 2000)
			}
			

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ :=require "./requireManage.js"

	initial: (_get-JSON)!->
		_init-JSON _get-JSON
		_init-table!
		_init-all-event!
		_init-depend-module!

module.exports = main-manage
