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
		@pic-upload-dom 					= @$el.find ".pic-field input#new-pic"
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

	init-all-event: !->
		@type-dom.change !~> @judge-show-or-hide-price-dom-by-price-dom @type-dom.val!

		@pic-upload-dom !~> @pic-upload-event @pic-upload-dom.files[0]

		@dc-type-dom.change !~> @dc-type-change-event @dc-type-dom.val!

		@cancel-btn-dom.click !-> eventbus.emit "view:page:toggle-page", "main"

		eventbus.on "controller:new:pic-change", (URL)!~> @apply-URL-to-pic URL

	judge-show-or-hide-price-dom-by-price-dom: (type)!->
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
