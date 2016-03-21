page = main = null
new-manage = let
	
	[get-Object-URL] = [util.get-Object-URL]

	_name-input-dom = $ "input\#new-name"
	_pic-input-dom = $ "input\#new-pic"
	_display-img-dom = $ "\#new-table .img-field .img"
	_cancel-btn-dom = $ "\#new-table .cancel-btn"
	_save-btn-dom = $ "\#new-table .save-btn"

	_is-wait = false
	_src = ""
	_name = ""

	_init-depend-module = !->
		page := require "./pageManage.js"
		main := require "./mainManage.js"

	_reset-all-input = !->
		_name-input-dom.val ''; _name := ""
		_pic-input-dom.val null; _src := ""
		_display-img-dom.css {"background-image" : ""}


	_init-all-event = !->
		_cancel-btn-dom.click !->
			_reset-all-input!
			page.toggle-page "main"
		_save-btn-dom.click !->
			if _check-is-valid! then _success-callback {
				name 	:	_name
				pic 	:	_src
				id 		:	123434
			}
		_pic-input-dom.change !->
			if file = @files[0]
				_src := util.getObjectURL file
				_display-img-dom.css({"background-image":"url(#{_src})"})

	_check-is-valid = ->
		_name := _name-input-dom.val()
		if _name.length is 0 then alert "请输入品类名称"; return false
		if _name.length > 21 then alert "输入的品类名称长度大于21"; return false
		if main.is-exist-name _name then alert "已存在该名字的品类, 请输入其他品类名"; return false
		return true


	_success-callback = (options)->
		main.add-new-category options
		_reset-all-input!
		page.toggle-page "main"


	initial: !->
		_init-all-event!
		_init-depend-module!




module.exports = new-manage