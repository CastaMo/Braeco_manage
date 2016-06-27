eventbus = require "../eventbus.js"
VBase = require "../Utils/VBase.js"

class SubitemMainView extends VBase
	(options)-> super options

	assign: (options)!->
		@subitem-main-controller 		= options.subitem-main-controller
		@subitem-modify-controller 	= options.subitem-modify-controller
		@subitem-model 							= options.subitem-model
		@page-controller 						= options.page-controller
		@$el 												= $ options.el-CSS-selector

	init-all-prepare: !->
		@all-subitem-doms = {}
		@datas 						= @subitem-model.get-datas!
		@subitem-list-dom = @$el.find "ul.subitem-list"
		@new-btn-dom 			= @$el.find ".new-btn"

	init-all-dom: !->
		for data in @datas when data.type isnt "property"
			@add-subitem-dom data.id

	init-all-event: !->

		@new-btn-dom.click !~> @new-btn-click-event!

		eventbus.on "model:subitem:remove-subitem", (subitem-id)!~> @remove-subitem-dom subitem-id

		eventbus.on "model:subitem:add-subitem", (subitem-id)!~> @add-subitem-dom subitem-id

		eventbus.on "model:subitem:update-subitem", (subitem-id)!~> @update-subitem-dom-by-id subitem-id

	new-btn-click-event: !->
		@page-controller.toggle-change "modify"
		set-timeout (!~> @subitem-modify-controller.toggle-to-add-subitem!), 200

	add-subitem-dom: (subitem-id)!->
		subitem-dom-object 							= {}
		$el = subitem-dom-object.$el 		= @create-subitem-dom!
		subitem-dom-object.name-dom 		= $el.find "\#name p"
		subitem-dom-object.remark-dom 	= $el.find "\#remark p"
		subitem-dom-object.price-dom 		= $el.find "\#price p"
		subitem-dom-object.num-dom 			= $el.find "\#num p"
		$el .find ".edit"
				.click !~>
					@page-controller.toggle-change "modify"
					set-timeout (!~> @subitem-modify-controller.toggle-edit-subitem-by-id subitem-id), 200

		$el .find ".remove"
				.click !~>
					if not confirm "确定要删除子项？(此操作无法撤销)" then return
					@subitem-main-controller.submit-data-and-try-require subitem-id, !->

		@all-subitem-doms[subitem-id] = subitem-dom-object
		@subitem-list-dom.append $el
		@update-subitem-dom-by-id subitem-id

	remove-subitem-dom: (subitem-id)!->
		subitem-dom-object = @all-subitem-doms[subitem-id]
		subitem-dom-object.$el.fade-out 200, !~>
			subitem-dom-object.$el.remove!
			delete @all-subitem-doms[subitem-id]

	update-subitem-dom-by-id: (subitem-id)!->
		subitem = @subitem-main-controller.get-subitem-by-id subitem-id
		subitem-dom-object = @all-subitem-doms[subitem-id]
		subitem-dom-object.name-dom.html subitem.name
		subitem-dom-object.remark-dom.html subitem.remark

		if subitem.type is "static_combo"
			price-inner-html = "固定价格, #{subitem.price}元"
		else
			price-inner-html = "折扣计价, #{Number((subitem.discount/100).to-fixed(2))}%"

		subitem-dom-object.price-dom.html price-inner-html

		subitem-dom-object.num-dom.html "#{subitem.content.length}款"



	create-subitem-dom: !->
		subitem-dom = $ "<li class='subitem'></li>"
		subitem-dom-inner-html = "<div class='subitem-elem-container parallel-container'>
															<div id='name'>
																<div class='name-field total-center'>
																	<p></p>
																</div>
															</div>
															<div id='remark' class='left-right-border'>
																<div class='remark-field total-center'>
																	<p></p>
																</div>
															</div>
															<div id='price'>
																<div class='price-field total-center'>
																	<p></p>
																</div>
															</div>
															<div id='num' class='left-right-border'>
																<div class='num-field total-center'>
																	<p></p>
																</div>
															</div>
															<div id='oper'>
																<div class='oper-field total-center'>
																	<div class='left-part'>
																		<div class='edit'>
																			<div class='icon'></div>
																			<p>修改</p>
																		</div>
																	</div>
																	<div class='right-part'>
																		<div class='remove'>
																			<div class='icon'></div>
																			<p>删除</p>
																		</div>
																	</div>
																	<div class='clear'></div>
																</div>
															</div>
															<div class='clear'></div>
														</div>"
		return subitem-dom.html subitem-dom-inner-html


module.exports = SubitemMainView