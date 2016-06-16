_my-wrap = !->
	@.wraps = $ '.wrap'
	@.blues = $ '.blue'
	that = @

	for let blue, i in @.blues
		$ blue .click -> 
			showWrap i
	@.wraps.find '.close_wrap' .click !->
		closeWrap($(@).parents '.wrap' .index!)
	@.wraps.find '.cancle' .click !->
		closeWrap($(@).parents '.wrap' .index!)
	@.wraps.find '.btn.confirm' .click !->
		curr = $ @ .parents '.wrap' .get(0)
		if curr.valid!
			curr.mysubmit!
	# **********************************************************
	# ************************ todo  ***************************
	# **********************************************************
	
	for temp in @.wraps
		temp.valid = !->
			if $ temp .attr('id') == 'wrap_pics'
				return true
			inputs = $ temp .find 'input'
			for x in inputs
				console.log x
				if !x.is-valid!
					return false
		
	showWrap =(index)!->
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
		temp.is-valid = (reg,str)->
			if @.value == '' || /^\s*$/g.test @.value
				@.showInputMessage '输入不可为空！'
				return false
			else if (@.getAttribute 'name' ) == 'phone'
				if ! /^[0-9\-\s]+$|^1[34578][0-9]{9}/.test @.value
					@.showInputMessage '只能输入固定座机或者手机号码哦！'
					return false
			return true
		$ temp .blur !->
			console.log($ @ )
			$ @ .val($ @ .val().replace myreg,'' )
		temp.showInputMessage = (str)!->
			alert(str)

_wrap-pics = !->
	that = util.getById 'wrap_pics'
	that.mychange = {}
	that.upload = {}
	$ '#wrap_pics' .find 'input[type=file]' .change !->
		index = $ @ .parents '.little_pic_li' .index!
		src = util.getObjectURL @.files[0]
		temp = {}
		temp.action ='change'
		temp.value = src
		that.mychange[index+''] = temp
		img-preview index,src
	$ '#wrap_pics' .find '.little_pic_li .delet_img' .click !->
		delete-img-input($ @ .parents('.little_pic_li').index!)
	# **********************************************************
	# ************************ todo  ***************************
	# *************** 需要放到测试服上进行测试 *****************
	# *********** 上传完所有图片，点击保存后才保存 *************
	# **********************************************************
	

	util.getById 'wrap_pics' .mysubmit = !->
		show-loading!
		for key of @.mychange
			if @.mychange[key].action == 'delete'
				ajax-for-delete @.mychange[key].value
			else if  @.mychange[key].action == 'change'
				ajax-for-token key,@.mychange[key].value
				# *******************************************************
				# ********************** todo  *****************
				# ************** 完成上传删除后提示 *************
				# ****************************************************
		text
		for key of @.upload
			text = key + ':' + @.upload[key] +'\n'
		alert(text);
		close-loading!
	ajax-for-token = (n,src)!->
		util.ajax {
			type : 'post'
			url : '/pic/upload/token/cover/' + n
			async :'async'
			success : (result)!->
				if result.message == 'success'
					ajax-for-qiniu result,src
			always : (result)!->
				console.log result
			unavailabled : (result)!->
				console.log result
			}
	# **********************************************************
	# ************************ todo  ***************************
	# *************** base64上传还是iframe？ *******************
	# **********************************************************
	ajax-for-qiniu = (data,src)!->
		util.ajax {
			type : 'post'
			url : 'http://upload.qiniu.com/'
			async :'async'
			data : {
				token : data.token
				key : data.key
				file : util.converImgTobase64 src				
			}
			success : (result)!->
				console.log result
				if result.message == 'success'
					that.upload[i+'']='上传成功'
					console.log 'success'
			always : (result)!->
				console.log result
			unavailabled : (result)!->
				that.upload[i+'']='上传失败，请重试'
				console.log result
		}
	ajax-for-delete = (n)!->
		util.ajax {
			type : 'post'
			url : '/Dinner/Cover/Remove/'+n
			async :'async'
			success : (result)!->
				console.log result
				if result.message == 'success'
					that.upload[n+'']='上传成功'
					console.log 'success'
			always : (result)!->
				console.log result
			unavailabled : (result)!->
				that.upload[n+'']='上传失败，请重试!'
				console.log result
		}
	img-preview = (index,src)!->
		$ '.little_pic_li' .eq index .find('img').attr 'src', src
		$ '.little_pic_li' .eq index .addClass 'pic'
		add-img-input!
	# **********************************************************
	# ************************ todo  ***************************
	# *************** 没有菊花图，家荣那里有一种 ***************
	# **********************************************************
	show-loading = (index)!->
		console.log '正在上传'
	close-loading = !->
		console.log '关闭菊花'
	add-img-input = !->
		n = ($ '.little_pic_li' .length) - ($ '.little_pic_li.pic' .length)
		if $ '.little_pic_li' .length < 5 && n<1
			last = $ '.little_pic_li:last'
			last.clone true .removeClass 'pic' .insertAfter(last)
	delete-img-input = (n)!->
		$ '.little_pic_li' .eq(n).remove!
		temp = {}
		temp.action = 'delete'
		temp.value = n
		that.mychange[n+''] = temp
		n = ($ '.little_pic_li' .length) - ($ '.little_pic_li.pic' .length)
		if(n == 0)
			add-img-input!
_my-carousel = !->
	asdf
_uplad-imgs = new _wrap-pics!
inputs = new _my-input $ '.wrap:not(#wrap_pics) input' 
wrap = new _my-wrap!


