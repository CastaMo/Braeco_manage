_my-wrap = !->
	@.wraps = $ '.wrap'
	@.blues = $ '.blue'
	that = @

	for let blue, i in @.blues
		$ blue .click -> 
			shoWrap i
	@.wraps.find '.close_wrap' .click !->
		closeWrap($(@).parents '.wrap' .index!)
	@.wraps.find '.cancle' .click !->
		closeWrap($(@).parents '.wrap' .index!)
	@.wraps.find '.btn.confirm' .click !->
		inputs = $ @ .parents '.wrap' .find 'input'
		flag = true
		for x in inputs
			if !x.is-vlaid!
				flag = false
		if flag == true
			send-ajax!
	send-ajax = !->
		console.log 'ajax'
	shoWrap =(index)!->
		$ '#wrap_contianer' .show!
		that.wraps.eq index .fadeIn 300
		that.wraps.eq index .find('input').val ''
	closeWrap = (index)!->
		$ '#wrap_contianer' .fadeOut 300
		that.wraps.eq index .hide!

_my-input = (input)!->
	# 特殊字符
	# myreg = /[~!<>#$%^&*()-+_=:]/g
	# 把四个特殊字符<>&\换成''
	myreg = /[<>&\\]/g
	@.input = input
	@.value = input.val()
	that = @
	for temp in @input
		temp.is-vlaid = (reg,str)->
			if @.value == '' || /^\s*$/g.test @.value
				console.log @
				@.showInputMessage '输入不可为空！'
				return false
			else if (@.getAttribute 'name' ) == 'phone'
				if ! /^[0-9\-\s]+$|^1[34578][0-9]{9}/.test @.value
					@.showInputMessage '只能输入固定座机或者手机号码哦！'
					return false
			return true
		temp.blur !->
			$ @ .val($ @ .val().replace myreg,'' )
		temp.showInputMessage = (str)!->
			alert(str)

inputs = new _my-input $ '.wrap input' 
wrap = new _my-wrap!


