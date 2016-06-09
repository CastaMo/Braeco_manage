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
	shoWrap =(index)!->
		$ '#wrap_contianer' .show!
		that.wraps.eq index .fadeIn 300
	closeWrap = (index)!->
		$ '#wrap_contianer' .fadeOut 300
		that.wraps.eq index .hide!

_my-input = (input)!->
	# 特殊字符
	myreg = /[~!<>#$%^&*()-+_=:]/g;
	@.input = input
	@.value = input.val()
	that = @
	@.isVlaid = (reg)!->
		if that.value == '' || /^\s*$/g.test that.value
			showInputMessage '输入不可为空！'
	@input.blur !->
		console.log($ @ .val!)
		$ @ .val($ @ .val().replace myreg,'' )
	showInputMessage = (str)!->
		alert(str)

inputs = new _my-input $ 'input' 
wrap = new _my-wrap!


