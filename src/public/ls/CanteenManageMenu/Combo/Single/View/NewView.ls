eventbus = require "../eventbus.js"

class NewView

	(options)->
		@assign options
		@init!

	assign: (options)!->
		@category-controller 			= options.category-controller
		@subitem-controller 			= options.subitem-controller
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
		@price-display-dom 				= @$el.find ".price-field .input-field"
		@price-dom 								= @$el.find ".price-field .input-field input"
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

		@cancel-btn-dom.click !~> @cancel-btn-click-event!

		@save-btn-dom.click !~> @save-btn-click-event!

		eventbus.on "controller:new:pic-change", (URL)!~> @apply-URL-to-pic URL

		eventbus.on "controller:new:reset", !~> @reset!

		eventbus.on "controller:new:add-subitem", !~> @add-subitem-dom!; @update-all-subitem-dom!

	type-dom-change-event: (type)!->
		if type is "combo_static" then @price-display-dom.fade-in 200
		else @price-display-dom.fade-out 200; @price-dom.val null

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

	cancel-btn-click-event: !-> eventbus.emit "view:page:toggle-page", "main"

	save-btn-click-event: !->
		@new-controller.set-config-data @get-config-data-by-input!
		if not @new-controller.check-is-valid! then return
		current-category-id = @category-controller.get-current-category-id!
		@new-controller.require-for-new-combo current-category-id

	apply-URL-to-pic: (URL)!->
		@pic-dom.css {"background-image": "url(#{URL})"}

	add-subitem-dom: !->
		subitem-dom-object = {}
		$el = subitem-dom-object.$el 						= @create-subitem-dom!
		subitem-dom-object.select-dom 					= $el.find "select"
		subitem-dom-object.input-dom 						= $el.find "input"
		subitem-dom-object.top-dom 							= $el.find ".top"
		subitem-dom-object.remove-dom 					= $el.find ".remove"
		subitem-dom-object.subitem-length-dom 	= $el.find ".subitem-length"
		subitem-dom-object.subitem-require-dom 	= $el.find ".subitem-require"
		@subitem-list-dom.append subitem-dom-object.$el
		@improve-for-subitem-dom-object subitem-dom-object
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
						<input type='number' min='0' value='1'>
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
						<span class='choose-hint'>
							( <span class='subitem-length'>20</span> 款单品任选
							<span class='subitem-require'>1</span>个)
						</span>
					</p>
				</div>
			</div>
			<div class='clear'></div>"
		subitem-dom.html subitem-dom-inner-html

	improve-for-subitem-dom-object: (subitem-dom-object)!->
		select-dom 						= subitem-dom-object.select-dom
		input-dom 						= subitem-dom-object.input-dom
		top-dom 							= subitem-dom-object.top-dom
		remove-dom 						= subitem-dom-object.remove-dom

		subitem-length-dom 		= subitem-dom-object.subitem-length-dom
		subitem-require-dom 	= subitem-dom-object.subitem-require-dom

		select-dom-inner-html = ""
		for subitem-id, subitem of @subitem-controller.get-all-subitems!
			remark-str = ""
			if subitem.get-remark! then remark-str = "(#{subitem.get-remark!})"
			select-dom-inner-html += "<option value=#{subitem.get-id!}>#{subitem.get-name!}#{remark-str}</option>"
		select-dom.html select-dom-inner-html

		select-dom.change !~> subitem-length-dom.html @subitem-controller.get-subitem-length(select-dom.val!)
		input-dom.keyup !~>
			value = input-dom.val!
			if value.length is 0 then return
			if Number(value) < 0 then return
			if value is "0" then value = "N"
			else value = parse-int value
			subitem-require-dom.html value
		top-dom.click !~>
			if subitem-dom-object.index is 0 then return
			@all-subitem-doms.splice subitem-dom-object.index, 1
			@all-subitem-doms.unshift subitem-dom-object
			subitem-dom-object.$el.detach! #保留原有事件
			@subitem-list-dom.prepend subitem-dom-object.$el
			@update-all-subitem-dom!
		remove-dom.click !~>
			if @all-subitem-doms.length is 1 then return
			subitem-dom-object.$el.remove!
			@all-subitem-doms.splice subitem-dom-object.index, 1
			@update-all-subitem-dom!

		subitem-length-dom.html @subitem-controller.get-subitem-length(select-dom.val!)
		subitem-require-dom.html parse-int input-dom.val!

	update-all-subitem-dom: !->
		for subitem-dom-object, i in @all-subitem-doms
			subitem-dom-object.index = i
			subitem-dom-object.top-dom.fade-in 200
		@all-subitem-doms[0].top-dom.fade-out 200

	get-config-data-by-input: !->
		groups = []
		require = []
		for subitem-dom-object in @all-subitem-doms
			groups.push subitem-dom-object.select-dom.val!
			require.push subitem-dom-object.input-dom.val!
		config-data =
			name 					: @c-name-dom.val!
			name2 				: @e-name-dom.val!
			type 					: @type-dom.val!
			price 				: @price-dom.val!
			tag 					: @remark-dom.val!
			detail 				: @intro-dom.val!
			dc_type 			: @dc-type-dom.val!
			dc 						: @dc-dom .find "input" .val!
			groups 				: groups
			require 			: require
		return config-data

	reset: !->
		@c-name-dom.val null; 										@e-name-dom.val null
		@type-dom.val "combo_static"
		@type-dom-change-event "combo_static"; 		@price-dom.val null
		@pic-upload-dom.val null;									@pic-dom.css {"background-image": ""}
		@subitem-list-dom.html null; 							@all-subitem-doms.length = 0
		@remark-dom.val null; 										@intro-dom.val null
		@dc-type-dom.val "none"; 									@dc-type-change-event "none"

module.exports = NewView
