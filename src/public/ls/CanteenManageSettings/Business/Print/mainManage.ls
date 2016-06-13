main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = require_ = null
	printer = []
	categories = []
	_cancel-btn-dom = $ "\.cancel-btn"
	_save-btn-dom = $ "\.save-btn"

	_init-JSON = (_get-JSON)!->
		all = get-JSON _get-JSON!
		printer := all['printer']
		categories := all['categories']

	_init-table = !->
		console.log "categories", categories
		for i from 0 to printer.length-1 by 1
			_new-printer = $ "<tr>
								<td class = 'printerID'></td>
								<td class = 'printerRemark'></td>
								<td class = 'printerSeparate'></td>
								<td class = 'printerPage'></td>
								<td class = 'printerSize'></td>
								<td>
									<div class = 'setting-btn btn'>
										<div class = 'test-icon'></div>
										<p>设置</p>
									</div>
									<div class = 'switch-btn btn'>
										<div class = 'test-icon'></div>
										<p>启用</p>
									</div>
								</td>
							</tr>"
			_new-printer.find(".printerID").html(printer[i].id)
			_new-printer.find(".printerRemark").html(printer[i].remark)
			if printer[i].separate is true
				_new-printer.find(".printerSeparate").html("是")
			else if printer[i].separate is false
				_new-printer.find(".printerSeparate").html("否")
			_new-printer.find(".printerPage").html("#{printer[i].page}联")
			if printer[i].size is 0
				_new-printer.find(".printerSize").html("小")
			else if printer[i].size is 1
				_new-printer.find(".printerSize").html("大")
			$('#Info').last().append _new-printer
			_new-printer.find(".setting-btn").click !->
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
						for j from 0 to categories.length-1 by 1
							_new-categories = $ "<li>
													<ul class = 'shown'>
														<li class = 'shown-item open'>
															<div class = 'open-icon'></div>
															<span class = '_name'></span>
															<input class = 'checkInput' type = 'checkbox'></input>
														</li>
													</ul>
												</li>"
							_new-categories.find("._name").html(categories[j].name)
							$(".allChoose").last().append _new-categories
							_new-categories.find(".shown-item").click !->
								if $(@).hasClass "open" and not $(event.target).hasClass "checkInput"
									$(@).removeClass "open"
									$(@).addClass "close"
									$(@).parent().find(".inner-shown-item").fade-out 100
								else if $(@).hasClass "close" and not $(event.target).hasClass "checkInput"
									$(@).removeClass "close"
									$(@).addClass "open"
									$(@).parent().find(".inner-shown-item").fade-in 100
							for k from 0 to categories[j].dishes.length-1 by 1
								_new-dish = $  "<li class = 'inner-shown-item'>
													<span class = 'dish_name'></span>
													<input type = 'checkbox'></input>
												</li>"
								_new-dish.find(".dish_name").html(categories[j].dishes[k].name)
								_new-categories.find(".shown").last().append _new-dish
						_else-dom = $ "<li>
											<ul class = 'shown'>
												<li class = 'shown-item open'>
													<div class = 'open-icon'></div>
													<span class = '_name'>其他</span>
													<input class = 'checkInput' type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>退款单</span>
													<input type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>呼叫服务</span>
													<input type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>日结</span>
													<input type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>支付宝二维码</span>
													<input type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>满减</span>
													<input type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>会员卡充值</span>
													<input type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>会员卡优惠</span>
													<input type = 'checkbox'></input>
												</li>
												<li class = 'inner-shown-item'>
													<span class = 'dish_name'>满送</span>
													<input type = 'checkbox'></input>
												</li>
											</ul>
										</li>"
						_else-dom.find(".shown-item").click !->
							if $(@).hasClass "open" and not $(event.target).hasClass "checkInput"
								$(@).removeClass "open"
								$(@).addClass "close"
								$(@).parent().find(".inner-shown-item").fade-out 100
							else if $(@).hasClass "close" and not $(event.target).hasClass "checkInput"
								$(@).removeClass "close"
								$(@).addClass "open"
								$(@).parent().find(".inner-shown-item").fade-in 100
						$(".allChoose").last().append _else-dom
				page.toggle-page "modify"

	_init-all-event = !->
		_cancel-btn-dom.click !->
			page.toggle-page "basic"

		_save-btn-dom.click !->
			page.toggle-page "basic"

	_init-depend-module = !->
		page := require "./pageManage.js"
		require_ :=require "./requireManage.js"

	initial: (_get-JSON)!->
		_init-JSON _get-JSON
		_init-table!
		_init-all-event!
		_init-depend-module!

module.exports = main-manage
