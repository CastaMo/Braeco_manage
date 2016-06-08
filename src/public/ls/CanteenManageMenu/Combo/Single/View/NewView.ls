eventbus = require "../eventbus.js"

class NewView

	(options)->
		@assign options
		@init!

	assign: (options)!->
		@new-controller 					= options.new-controller
		@$el 											= $ options.el-CSS-selector
		@dc-type-map-dc-options 	= options.dc-type-map-dc-options 

	init: !->
		@init-all-prepare!
		@init-all-event!

	init-all-prepare: !->
		@c-name-dom 							= @$el.find ".c-name-field input"
		@e-name-dom 							= @$el.find ".e-name-field input"
		@type-dom 								= @$el.find ".price-field select"
		@price-dom 								= @$el.find ".price-field input"
		@pic-upload-dom 					= @$el.find ".pic-field input\#new-pic"
		@pic-dom 									= @$el.find ".pic-field .img"
		@subitem-list-dom 				= @$el.find "ul.subitem-list"
		@subitem-new-btn-dom 			= @$el.find ".new-btn"
		@subitem-manage-btn-dom 	= @$el.find ".manage-btn"
		@remark-dom 							= @$el.find ".remark-field input"
		@intro-dom 								= @$el.find ".intro-field textarea"
		@dc-type-dom 							= @$el.find ".dc-field select"
		@dc-dom 									= @$el.find ".dc-field .addtional"
		@cancel-btn-dom 					= @$el.find ".cancel-btn"
		@save-btn-dom 						= @$el.find ".save-btn"

		@all-subitem-doms 				= []

	init-all-event: !->
		@type-dom.change !~> @type-dom-change-event @type-dom.val!

		@pic-upload-dom.change !~> @pic-upload-event @pic-upload-dom[0].files[0]

		@subitem-new-btn-dom.click !~> @new-controller.add-subitem!

		@dc-type-dom.change !~> @dc-type-change-event @dc-type-dom.val!

		@cancel-btn-dom.click !-> eventbus.emit "view:page:toggle-page", "main"

		eventbus.on "controller:new:pic-change", (URL)!~> @apply-URL-to-pic URL

		eventbus.on "controller:new:reset", !~> @reset!

		eventbus.on "controller:new:add-subitem", !~> @add-subitem-dom!; @update-all-subitem-dom!

	type-dom-change-event: (type)!->
		if type is "combo_sum" then @price-dom.fade-in 200
		else @price-dom.fade-out 200

	pic-upload-event: (file)!->
		if parse-int(file.size / 1024) > 4097 then return alert "图片大小不能超过4M"
		if file.type.substr(0, 5) isnt "image" then return alert "请上传正确的图片格式"
		@new-controller.pic-change file

	dc-type-change-event: (dc-type)!->
		@dc-dom.html ""
		if options = @dc-type-map-dc-options[dc-type]
			@dc-dom.html "<input type='number' placeholder='(#{options.min}-#{options.max})' max='#{options.max}' min='#{options.min}'>
											<p>#{options.word}</p>
											<div class='clear'></div>"

	apply-URL-to-pic: (URL)!->
		@pic-dom.css {"background-image": "url(#{URL})"}

	add-subitem-dom: !->
		subitem-dom-object = {}
		$el = subitem-dom-object.$el = @create-subitem-dom!
		@subitem-list-dom.append subitem-dom-object.$el
		@all-subitem-doms.push subitem-dom-object

	create-subitem-dom: ->
		subitem-dom = $ "<li class='subitem'></li>"
		subitem-dom-inner-html = "
			<div class='left-part'>
				<div class='name-field'>
					<p>子项</p>
				</div>
			</div>
			<div class='right-part'>
				<div class='basic-field parallel-container'>
					<div class='select-field'>
						<select>
							<options value='test'>测试</options>
						</select>
					</div>
					<div class='input-field parallel-container'>
						<p>任选个数</p>
						<input type='number' min='0'>
						<div class='clear'></div>
					</div>
					<div class='oper-field parallel-container'>
						<div class='top'>
							<div class='icon'></div>
						</div>
						<div class='remove'>
							<div class='icon'></div>
						</div>
						<div class='clear'></div>
					</div>
					<div class='clear'></div>
				</div>
				<div class='hint-field'>
					<p>
						<span class='choose-hint'>( 20 款单品任选1个)</p>
					</p>
				</div>
			</div>
			<div class='clear'></div>"
		subitem-dom.html subitem-dom-inner-html

	update-all-subitem-dom: !->
		for subitem-dom-object, i in @all-subitem-doms
			subitem-dom-object.index = i


	reset: !->
		@c-name-dom.val null; 										@e-name-dom.val null
		@type-dom.val "combo_sum"
		@type-dom-change-event "combo_sum"; 			@price-dom.val null
		@pic-upload-dom.val null;									@pic-dom.css {"background-image": ""}
		@subitem-list-dom.html null; 							@all-subitem-doms.length = 0
		@remark-dom.val null; 										@intro-dom.val null
		@dc-type-dom.val "none"; 									@dc-type-change-event "none"

module.exports = NewView
