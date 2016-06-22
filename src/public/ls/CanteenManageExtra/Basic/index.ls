do ->
	_my-wrap = !->
		@.wraps = $ '.wrap'
		@.blues = $ '.blue'
		that = @
		# **********************************************************
		# ************************ todo  ***************************
		# **********************************************************
		for let temp in @.wraps
			temp.valid = ->
				if($ temp .attr('id')=='wrap_pics')
					return true
				inputs = $ temp .find 'input'
				for x in inputs
					if !x.is-valid!
						return false
				if($ temp .attr('id')=='wrap_password')
					if inputs[0].value == inputs[1].value
						inputs[1].show-message '新密码不能和旧密码一样哦！'
						return false
					if inputs[1].value != inputs[2].value
						inputs[2].show-message '确认密码应该和新密码一样哦！'
						return false
				return true
			temp.get-my-data = ->
				data ={}
				if($ temp .attr('id')=='wrap_pics')
					return null
				inputs = $ temp .find 'input'
				for x in inputs
					name = x.getAttribute 'name'
					if name == 'password'
						data[name] = jQuery.md5 x.value
					data[name] = x.value
				data
			if temp.getAttribute 'id' !='wrap_pics'
				temp.mysubmit =(mydata,myurl)->
					util.ajax {
					type : 'post'
					url : '/User/Update/Profile'
					async :'async'
					data : JSON.stringify mydata
					success : (result)!->
						ajax-callback result
					unavailabled : (result)!->
						show-global-message '提交失败，请重试！'
					}

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
				curr.mysubmit curr.get-my-data!
		showWrap =(index)!->
			$ '#wrap_contianer' .show!
			that.wraps.eq index .fadeIn 300
			that.wraps.eq index .find('input').val ''
		closeWrap = (index)!->
			$ '#wrap_contianer' .fadeOut 300
			that.wraps.eq index .hide!
		ajax-callback = (result)!->
			if result.message == 'success'
				location.reload true
			else if 'Wrong password'
				show-global-message '原密码<b>错误</b>,请重新输入'
				$ '#wrap_password input' .eq 0 .val ''
				$ '#wrap_password input' .eq 0 .focus!
			else
				show-global-message '提交失败，原因：'+result.message

	_my-inputs = (input)!->
		# 特殊字符
		# myreg = /[~!<>#$%^&*()-+_=:]/g
		# 把四个特殊字符<>&\换成''
		myreg = /[<>&\\]/g
		@.inputs = input
		that = @
		for let temp in @inputs
			temp.is-valid = (reg,str)->
				if @.value == '' || /^\s*$/g.test @.value
					@.show-message '输入不可为空！'
					return false
				# 固定电话和手机号码的验证太麻烦，此处略过
				# else if (@.getAttribute 'name' ) == 'phone'
				# 	if ! /^[0-9\-\s]+$|^1[34578][0-9]{9}/.test @.value
				# 		@.show-message '只能输入固定座机或者手机号码哦！'
				# 		console.log 'phone'
				# 		return false
				return true
			$ temp .blur !->
				$ @ .val($ @ .val().replace myreg,'' )
			temp.show-message = (str)!->
				$ temp .focus!
				show-global-message str

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
			show-global-message text
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
					show-global-message '提交失败，原因：'+result
				}
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
	time-out-id = ''
	# 显示全局信息提示
	show-global-message = (str)->
		ob = $ '#global_message' 
		ob.show!
		ob.html str 
		clearTimeout time-out-id
		time-out-id := setTimeout('$("#global_message").fadeOut(300)',2000)
	_uplad-imgs = new _wrap-pics!
	inputs = new _my-inputs $ '.wrap:not(#wrap_pics) input' 
	wrap = new _my-wrap!
