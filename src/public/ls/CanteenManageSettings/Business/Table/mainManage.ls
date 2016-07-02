main-manage = let
	_all-data = null
	Wrap = !->
		tables = []
		operations = []
		covers = []
		for let x in $ '.table_qr' 
			temp = new Table x
			$ temp.prototype.dom .click !~>			
				temp.prototype.change-click-state!
				change-num-tip!
			tables.push temp
		for x in $ '.table_operation'
			operations.push(new Operation x)

		add-new = tables[tables.length-1].prototype
		$ add-new.dom .click !->
			show-wrap 1,@

		$ add-new.dom .find '.cancle' .click !->
			$ add-new.change-click-state!	

		# 选择所有
		$ operations[0].dom .click ->
			operations[0].change-click-state!
			select_all operations[0].able
		# 添加、修改、导出、删除
		# 先确定已经选择座位，再显示弹出框
		for let i from 1 to 4
			$ operations[i].dom .click ->
				# 添加
				if(i == 1)
					show-wrap 0,0
				else
					if get-disabled-table-num! >0
						switch $ @ .index!
						case 2  then  show-wrap 1,get-first-disabled-table!
						case 3  then  show-wrap 0,1
						case 4  then  show-wrap 0,6
					else
						alert '要先点击选择桌位哦！'
		# 导出二维码
		for win in $ '.wrap.batch_export:gt(0)'
			new-cover = new Cover win,'/Table/Qrcode/Download',(
				(result)!->
					result = JSON.parse result
					if result.message == 'success'
						alert '桌号正在生成，稍后发送到您的邮箱，请稍等！'
			)
			covers.push(new-cover)
		# 单个桌位修改
		for win in $ '.popup.edit:not(last)'
			new-cover = new Cover win,'/table/edit',(
				(result)!->
					result = JSON.parse result
					if result.message == 'success'
						alert '修改成功',true
						set-timeout (!->location.reload!), 2000
					else if result.message =='Table exist'
						alert '新的桌号已经存在'
					else
						alert result.message
			)
			covers.push(new-cover)
		# 单个桌位添加
		# 批量桌位添加
		for win in $ '.batch_add'
			new-cover = new Cover win,'/Table/add',(
				(result)!->
					result = JSON.parse result
					if result.message == 'success'
						alert '添加成功',true
						set-timeout (!->location.reload!), 2000
					else if result.message == 'Invalid numbe'
						alert '参数取值范围非法'
					else if result.message == 'Duplicate entry'
						alert '存在重复桌号'
					else if 'Used word'
						alert '该桌号已经存在'
					else
						alert result.message
				)
			covers.push(new-cover)
		# 批量桌位删除
		new-cover = new Cover ($ '.batch_delete' .get 0),'/Table/remove',(
			(result)!->
				result = JSON.parse result
				if result.message == 'success'
					alert '删除成功',true
					set-timeout (!->location.reload!), 2000
				else if result.message == 'Empty content'
					alert '桌号为空'
				else
					alert result.message
			)
		covers.push(new-cover)
		# 选择导出模板
		covers.push(new Base-cover($ '.wrap.batch_export1'))

		$ '.imgli' .click ->
			$ '.imgli' .removeClass 'selected'
			$ @ .addClass 'selected'
		$ '.wrap.batch_export1 .btn.confirm' .click !->
			i = $ '.imgli.selected' .index!
			if i>=0
				show-wrap 0, i+2
			else
				alert '要先点击选择模板哦！'
		$ 'select[name=pay]' .change !->
			_change-module!
		$ 'select[name=discount]' .change !->
			_change-module!
		_change-module =!->
			wrap = $ '.wrap:visible' 
			a = 'http://static.brae.co/export/qrcode/'
			a += wrap.attr 'type'
			a += wrap.find 'select[name=pay]' .val!
			a += wrap.find 'select[name=discount]' .val!
			a += '.png'
			wrap.find '.wrap_right img' .attr 'src',a

		select_all = (flag)!->
			if flag == false
				$ '.table_operation.select_all .selected_num' .text '('+(($ '.table_qr').length-1)+'/'+(($ '.table_qr').length-1)+')'
			else
				$ '.table_operation.select_all .selected_num' .text '(0/'+(($ '.table_qr').length-1)+')'
			for x,i in tables
				if i<tables.length-1
					x.prototype.change-click-state flag 

		# i = 0 : wrap   arg1表示wrap的下标,arg2表示这个wrap需要的参数
		#          0 批量添加             input清空
		#          1 导出选择模板         .imgli 去掉 selected class
		#          2 裸码                 input 清空
		#          3 桌贴方               input、select 清空
		#          4 桌贴圆               input、select 清空
		#          5 桌牌 细长            input、select 清空
		#          6 批量删除             添加已选择的桌号
		# i = 1 : popup  arg1表示table_tr 的dom，单个添加、编辑小弹窗
		show-wrap = (i,arg1)!->
			switch i
			case 0 then 
				wrap = $ '.wrap' .eq arg1
				$ '.wrap' .hide!
				$ '#wrap' .show! 
				wrap.fadeIn 300
				switch arg1
				case 0,2,3,4,5 then 
					wrap.find 'input' .val ''
					wrap.find 'select' .val ''
					disable-download-directly wrap,arg1
				case 1 then wrap.find '.imgli' .removeClass 'selected'
				case 6 then
					selected = get-disabled-table!
					a = ''
					for temp,i in selected
						a += '、' + $ selected[i] .find '.num' .text!
					wrap.find '.delete_tables b' .text ' '+a.substr 1
			case 1 then
				$ '#popup_cover' .show!
				little-wrap = $ arg1 .find '.edit'
				little-wrap.find 'input' .val($ arg1 .find '.num' .text!)
				little-wrap.fadeIn 300
		# i= 2       裸码，限制50个
		# i= 3、4、5 其他码，限制25个
		disable-download-directly = (ob,i)!->
			num = get-disabled-table-num!
			if i==2
				ob.find '.message b' .text (num*0.5).toFixed(1)
				if num>50
					disable-select-email ob.find 'select[name=send_email]',(num*0.5).toFixed(1)
			else if i==3||i==4||i==5
				ob.find '.message b' .text num
				if num>25
					disable-select-email ob.find 'select[name=send_email]',num
		disable-select-email = (ob,t)!->
			ob.val('1')
			ob.prop('disabled',true)
			ob.parents('.inputli').next().hide()
		# 获取选中的桌位数目
		get-disabled-table-num = ->
			num = 0
			for x,i in tables
				if x.prototype.able == false
					num +=1
			num
		# 获取选中的桌位dom
		get-disabled-table = ->
			for x,i in tables
				if x.prototype.able == false
					x.prototype.dom
		get-first-disabled-table = ->
			for x,i in tables
				if x.prototype.able == false
					return x.prototype.dom
			return null
		# 显示选中的number
		change-num-tip =!->
			$ '.table_operation.select_all .selected_num' .text '('+get-disabled-table-num!+'/'+(($ '.table_qr').length-1)+')'
		# 导出二维码的输入框们
		$ '.wrap select' .change ->
			if ($ @ .attr 'name')!='pay'
				select-change ($ @ .parents '.inputli'),($ @ .val!),($ @ .attr 'name')=='wifi'
		select-change = (ob,val,iswifi)!->
			val  = parseInt val
			if iswifi == true
				if val>=0
					ob.next!.hide!
					ob.next!.next!.hide!
				if val>=1
					ob.next!.show!
					if val>=2
						ob.next!.next!.show!
			else
				if val ==0
					ob.next!.hide!
				if val==1
					ob.next!.show!

	Operation = (op)->
		@prototype = new Change-state op
		that = @prototype

	Table = (t)->
		@prototype = new Change-state t
		that = @prototype
		$ that.dom .find '.popup' .click ->
			return false
		@
	Change-state = (ob)->
		@able = !$ ob .hasClass 'disabled'
		@dom = ob
		@change-click-state = (state)!~>
			if state!=undefined
				@able = state
			else
				@able = !@able
			if @able
				$ @dom .removeClass 'disabled'
			else 
				$ @dom .addClass 'disabled'
		@
	My-input = (ob)->
		@dom = ob
		@empty = ~>
			if $ @dom .val! == '' || /\s/.test($ @dom .val!)
				alert '输入不可为空'
				return true
			return false
		@valid =(reg)~>
			if ($ @dom .is ':visible' )== false
				return true
			val = @dom.value
			if @empty!
				return false
			if reg!=undefined
				if !reg.test val
					return false
			if $ @dom .hasClass 'table_name'
				if val.length>4
					alert '桌位号太长啦，请不要超过四哦'
					return false
			# 验证邮箱是否合法
			if ($ @dom .attr 'name')=='email'
				if !/^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/.test val
					alert '请输入正确的邮箱地址！'
					return false
			# 数字输入框的长度
			len = $ @dom .attr 'length' 
			if len!=undefined
				if (!/\d/.test len)||(val.length>parseInt len)
					alert '该输入框只能输入数字，且长度不能大于'+len
					return false
			return true
		@focus =!~>
			$ @dom .focus!
		@

	# type:true  表示wrap
	# type:false 表示popup
	# ob:dom对象
	Cover = (ob,url,success)->
		@prototype = new Base-cover ob
		@inputs = []
		_url = url
		_success = success
		self = @prototype

		for x in $ self.dom .find 'input'
			@inputs.push new My-input x
		$ self.dom .find '.btn.confirm' .click !~>
			if @valid!
				if $ self.dom .hasClass 'batch_export'
					if $ self.dom .find 'select[name=send_email]' .val! == '0'
						$ '#export input[name=data]' .val(JSON.stringify @.get-cover-data!)
						$ '#export' .submit!
					else 
						@mysubmit!
				else 
					@mysubmit!

		@mysubmit = (url,success)!~>
			util.ajax {
				type :'post'
				url : _url
				data : JSON.stringify @.get-cover-data!
				success : _success
				unavailabled : (result)!->
					alert '请求失败'+result
			}
		@valid = !~>
			for x in @inputs
				if !x.valid!
					x.focus!
					return false
			return true
		@get-cover-data =~>
			if $ self.dom .hasClass 'batch_export'
				return get-qrcode-data!
			else if $ self.dom .hasClass 'batch_delete'
				return get-disabled-table-text!
			else
				get-input-data!

		get-input-data = (data)~>
			data = data||{}
			for x in @inputs
				data[x.dom.getAttribute 'name' ] = x.dom.value
			data

		# 获取qrcode的数据
		get-qrcode-data = ~>
			mydata = get-select-val!
			mydata.content = get-disabled-table-text!
			for x in $ self.dom .find 'input:visible'
				mydata[$ x .attr 'name'] = $ x .val!
			mydata.type = $ self.dom .attr 'type'
			mydata
		get-disabled-table-text =->
			for temp in $ '.table_qr.disabled'
				$ temp .find '.num' .text!
		get-select-val = ~>
			mydata = {}
			for x in $ self.dom .find 'select'
				mydata[$ x .attr 'name' ] = $ x .val!
			mydata
		@
	Base-cover = (ob) ->
		@dom = ob
		@type = $ @dom .hasClass 'wrap'

		$ @dom .find '.cancle_cross,.btn.cancle' .click !~>
			@close-wrap!

		# i = '.wrap'  
		# i = '.poput' 
		@close-wrap = !~>
			if @type
				$ '#wrap' .fadeOut 300
				$ @dom .hide!
			else 
				$ @dom .fadeOut 300
				$ '#popup_cover' .hide!
		@
	time-out-id = ''
	class init-all-data 
		(d) ->
			_all-data := d
			_init!
		_init =->
			_initial-new-table = $ '.table_qr.new'
			for x in _all-data
				_new-table = _initial-new-table.clone(true)
				_new-table.find '.table_qr_light img' .attr 'src',x.url
				_new-table.find '.table_qr_light .num' .text x.word
				_new-table.removeClass 'new'
				_new-table.insertBefore _initial-new-table
			_initial-new-table.remove!
			$ '.table_operation.select_all .selected_num' .text '(0/'+_all-data.length+')'

	initial: (json-data)!->
		init-all-data json-data
		tables = new Wrap!

module.exports = main-manage
