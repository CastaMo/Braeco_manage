do ->
	My-wrap = !->
		@wraps = $ '.wrap'
		@blues = $ '.blue'
		self = @
		# **********************************************************
		# ************************ todo  ***************************
		# **********************************************************
		for let temp in @wraps
			temp.valid = ->
				if($ temp .attr('id')=='wrap_pics')
					return true
				inputs = $ temp .find 'input'
				for x in inputs
					if !x.is-valid!
						return false
				if($ temp .attr('id')=='wrap_password')
					if inputs[0].value == inputs[1].value
						return inputs[1].show-message '新密码不能和旧密码一样哦！'
					if inputs[1].value != inputs[2].value
						return inputs[2].show-message '确认密码应该和新密码一样哦！'
				return true
			temp.get-my-data = ->
				data ={}
				if($ temp .attr('id')=='wrap_pics')
					return null

				inputs = $ temp .find 'input'
				for x in inputs
					name = x.getAttribute 'name'
					if name == 'oldpass'
						data[name] = $.md5 x.value
					else if name == 'printer'
						data[name] = $ 'input[name=printer]:checked' .val!
					else
						data[name] = x.value
				data
			if temp.getAttribute('id')!='wrap_pics'
				temp.mysubmit =(mydata,myurl)->
					util.ajax {
					type : 'post'
					url : '/Dinner/Update/Profile'
					async :'true'
					data : JSON.stringify mydata
					success : (result)!->
						ajax-callback result
					unavailabled : (result)!->
						alert '提交失败，请重试！'
					}

		for let blue, i in @blues
			$ blue .click -> 
				showWrap(i,$ @ .parents '.info_li' .find '.info_value' .text!)

		@wraps.find '.close_wrap' .click !->
			closeWrap($(@).parents '.wrap' .index!)
		@wraps.find '.cancle' .click !->
			closeWrap($(@).parents '.wrap' .index!)
		@wraps.find '.btn.confirm' .click !->
			curr = $ @ .parents '.wrap' .get(0)
			if curr.valid!
				curr.mysubmit curr.get-my-data!
		showWrap =(index,str)!~>
			if index<@wraps.length
				w = @wraps.eq index 
				$ '#wrap_contianer' .show!
				w.fadeIn 300
				if index != 5
					w.find('input').val ''
				if index>0&&index<4
					w.find '.wrap_input span' .html str
		closeWrap = (index)!->
			$ '#wrap_contianer' .fadeOut 300
			self.wraps.eq index .hide!
		ajax-callback = (result)!->
			result = JSON.parse result
			if result.message == 'success'
				alert '修改成功',true
				set-timeout (!->location.reload!), 2000
			else if result.message == 'Wrong password'
				alert '原密码<b>错误</b>,请重新输入'
				$ '#wrap_password input' .eq 0 .val ''
				$ '#wrap_password input' .eq 0 .focus!
			else if result.message == 'message:Used email'
				alert '修改失败，该邮箱已被使用！'
			else
				alert '提交失败，原因：'+result.message

	My-inputs = (input)!->
		# 特殊字符
		# myreg = /[~!<>#$%^&*()-+_=:]/g
		# 把四个特殊字符<>&\换成''
		myreg = /[<>&\\]/g
		@inputs = input
		self = @
		for let temp in @inputs
			temp.is-valid = (reg,str)->
				if @.getAttribute('type')== 'radio'
					if $ 'input[name=printer]:checked' .val! == undefined
						return @show-message '请选择一个打印机'
				else 
					if @.getAttribute('empty_is_vlaid') != 'true' || @.value!=''
						if @value == '' || /^\s*$/g.test @value
							return @show-message '输入不可为空！'
						if (@getAttribute 'type' ) == 'password'
							if @value.length<6 || @value.length>16
								return @show-message '密码长度为6-16个字符'
						if (@getAttribute 'name' ) == 'email'
							if ! /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/.test @value
								return @show-message '请输入正确的邮箱地址'
						# 固定电话和手机号码的验证太麻烦，此处略过
						# else if (@getAttribute 'name' ) == 'phone'
						# 	if ! /^[0-9\-\s]+$|^1[34578][0-9]{9}/.test @value
						# 		@show-message '只能输入固定座机或者手机号码哦！'
						# 		console.log 'phone'
						# 		return false
				return true				
			$ temp .blur !->
				$ @ .val($ @ .val().replace myreg,'' )
			temp.show-message = (str)->
				$ temp .focus!
				alert str
				return false

	Wrap-pics = !->
		self = util.getById 'wrap_pics'
		$ self .find 'input[type=file]' .change !->
			ob = $ @ .parents '.little_pic_li' 
			index = ob.index!
			ob.addClass 'change'
			img-preview index,util.getObjectURL(@.files[0])
			ajax-for-token ob,index
		$ self .find '.little_pic_li .delet_img' .click !->
			delete-img-input($ @ .parents('.little_pic_li').index!)
		
		self.mysubmit = !->
			show-loading!
			keys = []
			for x in $ self .find '.little_pic_li.pic:visible'
				keys.push x.getAttribute 'key'
			ajax-for-renew(keys)

		after-upload-img = ->
			close-loading!
			set-timeout (!->location.reload!), 2000
		ajax-for-token = (ob,n)!->
			util.ajax {
				type : 'post'
				url : '/Pic/Upload/Token/Covertemp'
				async :'true'
				success : (result)!->
					result = JSON.parse result
					if result.message == 'success'
						ob.attr 'key',result.key.substr(14)
						ajax-for-qiniu result,n
				unavailabled : (result)!->
					alert '上传失败，请重试'
				}
		ajax-for-qiniu = (data,n)!->
			$ '.form' .eq n .find 'input[name=token]' .val data.token
			$ '.form' .eq n .find 'input[name=key]' .val data.key
			$ '.form' .eq n .submit!
		ajax-for-renew =(keys)!->
			util.ajax {
				type : 'post'
				url : '/Dinner/Cover/Renew'
				async :'true'
				data : JSON.stringify keys
				success : (result)!->
					result = JSON.parse result
					if result.message == 'success'
						alert '修改成功！'
						after-upload-img!
				unavailabled : (result)!->
					alert '保存失败，请重试'
					set-timeout (!->location.reload!), 2000
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
			_show_global_message '正在上传...'
		close-loading = !->
			_close_global_message!
		add-img-input = (pic)!->
			len = $ '.little_pic_li.pic:visible' .length
			if len<5
				$ '.little_pic_li' .eq len .css 'display','inline-block'
		delete-img-input = (n)!->
			ob = $ '.little_pic_li' .eq n
			ob.hide!
			ob.removeClass 'pic'
			ob.insertAfter $ '.little_pic_li:visible:last' 
			n = ($ '.little_pic_li:visible' .length) - ($ '.little_pic_li.pic' .length)
			if(n == 0)
				add-img-input 'pic'
	My-carousel = (dom)!->
		@dom = dom
		@imgs = $ dom .find '.carousel_img'
		@interval-id = ''
		self = @

		$ @dom .find '.carousel_img' .eq 0 .addClass 'active'
		$ @dom .find '.carousel_dot' .eq 0 .addClass 'active'
		_add-carousel-animation = !~>
			if @imgs.length>1
				if @interval-id != ''
					clearInterval @interval-id
				
				@interval-id = setInterval(
					!->
						_an-animation($ self.dom .find '.carousel_img.active' .index!)
					,3000)
			else
				$ @imgs .show!
		$ @dom .find '.carousel_dot' .click ->
			i = $ @ .index!
			if i - 1 < 0
				vanish = self.imgs.length-1
			else
				vanish = i-1
			_an-animation vanish
			_add-carousel-animation self.interval-id
		_an-animation =(i)!~>
			if i+1>=@imgs.length
				show=0
			else
				show=i+1
			$ @dom .find '.carousel_img' .hide!
			_my-slide @imgs[i],'0','-100%',1,0
			_my-slide @imgs[show],'100%','0',0,1
			$ @dom .find '.carousel_img.active' .removeClass 'active'
			$ @dom .find '.carousel_dot.active' .removeClass 'active'
			$ @imgs[show] .addClass 'active'
			$ @dom .find '.carousel_dot' .eq(show).addClass 'active'

		_my-slide = (ob,origin,dest,op1,op2)!->
			$ ob .stop!
			$ ob .css {'left':origin,'display':'block','opacity':op1}
			$ ob .animate {'left':dest,'opacity':op2},1000
		_add-carousel-animation!

	_show_global_message = (str)!->
		$ '#global_message' .html str
		$ '#global_message' .fade-in 300
	_close_global_message=!->
		$ '#global_message' .fade-out 300

	_uplad-imgs = new Wrap-pics!
	wrap = new My-wrap!

# ********************************************************************************
# *********************************** 初始  **************************************
# ********************************************************************************
	_main-init =(d)!->

		$ '.info_value' .eq 0 .text d.data.phone
		_set-or-edit($ '.info_value' .eq(1),d.data.email)
		$ '.info_value' .eq 2 .text d.data.dinner_name
		_set-or-edit($ '.info_value' .eq(3),d.data.address)
		_set-or-edit($ '.info_value' .eq(4),d.data.contact_phone)
		if d.data.covers!=null
			$ '.info_value.info_img:eq(0) img' .attr 'src',d.data.covers[0]
			for x,i in d.data.covers
				$ '#carousel .carousel_imgs' .append('<img class="carousel_img" src="'+x+'"></img>')
				$ '#carousel .carousel_dots' .append('<div class="carousel_dot"></div>')
				newPic = $ '.little_pic_li' .eq i
				newPic.attr('self_order',i)
				newPic.attr('key',x.substr(36))
				newPic.find 'img' .attr 'src',x
				newPic.addClass 'pic'
			if d.data.covers.length<5
				$ '.little_pic_li' .eq d.data.covers.length .css 'display','inline-block'
		else 
			$ '.little_pic_li' .eq 0 .css 'display','inline-block'
		if d.data.wxpay
			$ '.info_value.info_img1 img' .attr 'src',d.data.wxpay.qrurl
			$ 'input[name=page]' .val d.data.wxpay.page
			for x in d.data.wxpay.printer
				$ '.wrap_printers' .eq 0 .append('<label class="printer">'+x.remark+'<input value="' + x.id + '" name="printer" type="radio"></label>')
			select_printer = parseInt d.data.wxpay.select_printer
			if select_printer>0
				ob = $ 'input[value='+select_printer+']' 
				$ '.wrap_printers' .eq 0 .prepend(ob.parents '.printer' .remove!)
				ob.attr 'checked',true
		carousel = new My-carousel $ '#carousel'
		inputs = new My-inputs $ '.wrap:not(#wrap_pics) input' 
	_set-or-edit =(ob,x)!->
		if x!=undefined
			ob.text x
		else
			ob.next!.text('设置')

	if window.all-data 
		then _main-init JSON.parse window.all-data; window.all-data = null;
	else 
		window.main-init = _main-init;

