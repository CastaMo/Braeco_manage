main-manage = let
	_all-data = null
	Wrap = !->
		tables = []
		operations = []
		covers = []
		for x in $ '.table_qr' 
			tables.push(new Table x )
		for x in $ '.table_operation'
			operations.push(new Operation x)

		add-new = tables[tables.length-1].prototype
		$ add-new.dom .click !->
			show-wrap 1,@,'.edit'

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
						case 2  then  show-wrap 1,get-first-disabled-table!,'.edit'
						case 3  then  show-wrap 0,1
						case 4  then  show-wrap 0,5
					else
						show-global-message '要先点击选择桌位哦！'
		for win in $ '.wrap:not(.batch_export1), .popup'
			new-cover = new Cover win
			new-cover.mysubmit = !~>
				util.ajax {
					type : 'post'
					url : @url
					async :'async'
					data : JSON.stringify @get-cover-data!
					success : (result)!->
						console.log result
						if result.message == 'success'
							location.reload true
					always : (result)!->
						console.log result
					unavailabled : (result)!->
						console.log result
				}
			covers.push(new-cover)
		covers.push(new Base-cover($ '.wrap.batch_export1'))

		$ '.imgli' .click ->
			$ '.imgli' .removeClass 'selected'
			$ @ .addClass 'selected'
		$ '.wrap.batch_export1 .btn.confirm' .click !->
			i = $ '.imgli.selected' .index!
			if i>=0
				if i == 0
					show-wrap 0,3
				else if i == 3
					show-wrap 0,4
				else
					show-wrap 0,2,i
			else
				show-global-message '要先点击选择模板哦！'
		select_all = (flag)!->
			for x,i in tables
				if i<tables.length-1
					x.prototype.change-click-state flag 

		# i = 0 : wrap   arg1表示wrap的下标,arg2表示这个wrap需要的参数
		# i = 1 : popup  arg1表示table_tr 的dom，arg2 表示'.edit'或者'.delete'
		show-wrap = (i,arg1,arg2)!->
			switch i
			case 0 then 
				wrap = $ '.wrap' .eq arg1
				$ '.wrap' .hide!
				$ '#wrap' .show! 
				wrap.fadeIn 300
				switch arg1
				case 0,3 then 
					wrap.find 'input' .val ''
				case 1 then wrap.find '.imgli' .removeClass 'selected'
				case 2 then
					arr = ['squre','circle','card']
					wrap.attr('type',arr[arg2-1])
					wrap.find 'input' .val ''
					wrap.find 'select' .val ''
					wrap.find '.wrap_right img' .attr('src',$ '.batch_export1 .imgli.selected img' .attr 'src' )
				case 4 then
					#桌牌
				case 5 then
					selected = get-disabled-table!
					a = ''
					for temp,i in selected
						a += '、' + $ selected[i] .find '.num' .text!
					wrap.find '.delete_tables b' .text ' '+a.substr 1
			case 1 then
				$ '#popup_cover' .show!
				little-wrap = $ arg1 .find arg2
				if(arg2 == '.edit')
					little-wrap.find 'input' .val($ arg1 .find '.num' .text!)
				little-wrap.fadeIn 300
			
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
		# 导出二维码的输入框们
		$ '.wrap.batch_export2 select' .change ->
			select-change($ @ .parents '.inputli' .index!,$ @ .val!)
		select-change = (n,val)!->
			inputlis = $ '.wrap.batch_export2 .inputli'
			switch n
			case 1  then    #折扣优惠
				show-inputli val,inputlis.eq 2
			case 3 then    #wifi密码
				show-inputli val,inputlis.eq(5),inputlis.eq 4 
			case 6 then     #发送邮箱
				show-inputli val,inputlis.eq 7
		show-inputli =(flag,ob1,ob2)!->
			if(ob2)
				ob2.show!
			if flag == '0'
				ob1.show!
			else if flag == '1'
				ob1.hide!
			else if flag == '2'
				ob2.hide!

	Operation = (op)->
		@prototype = new Change-state op
		that = @prototype

	Table = (t)->
		@prototype = new Change-state t
		that = @prototype
		$ that.dom .click !~>			
			that.change-click-state!
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
				show-global-message '输入不可为空'
				return true
			return false
		@valid =(reg)~>
			val = @dom.value
			if @empty!
				return false
			if reg!=undefined
				if !reg.test val
					return false
			if $ @dom .hasClass 'table_name'
				if val.length>4
					show-global-message '桌位号不能太长哦！'
					return false
			return true
		@focus =!~>
			$ @dom .focus!
		@

	# type:true  表示wrap
	# type:false 表示popup
	# ob:dom对象
	Cover = (ob)->
		@prototype = new Base-cover ob
		@inputs = []
		that = @prototype

		for x in $ that.dom .find 'input'
			@inputs.push new My-input x
		$ that.dom .find '.btn.confirm' .click !~>

			if @valid!
				@mysubmit!

		@valid = !~>
			for x in @inputs
				if !x.valid!
					x.focus!
					return false
			return true
		@get-cover-data =~>
			if $ that.dom .hasClass 'batch_export2'
				return get-qrcode-data!
			else if $ that.dom .hasClass 'batch_delete'
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
			for x in $ '.batch_export2 input:visible'
				mydata[$ x .attr 'name'] = $ x .val!
			mydata.type = $ '.batch_export2' .attr 'type'
			mydata
		get-disabled-table-text =->
			for temp in $ '.table_qr.disabled'
				$ temp .find '.num' .text!
		get-select-val = ->
			mydata = {}
			for x in $ '.batch_export2 select'
				mydata[$ x .attr 'name' ] = $ x .val!
			mydata
		@
	Base-cover = (ob) ->
		@dom = ob
		@type = $ @dom .hasClass 'wrap'

		$ @dom .find '.cancle_cross,.btn.cancle' .click !~>
			close-wrap!

		# i = '.wrap'  
		# i = '.poput' 
		close-wrap = !~>
			if @type
				$ '#wrap' .fadeOut 300
				$ @dom .hide!
			else 
				$ @dom .fadeOut 300
				$ '#popup_cover' .hide!
		@
	time-out-id = ''
	# 显示全局信息提示
	show-global-message = (str)->
		ob = $ '#global_message' 
		ob.show!
		ob.html str 
		clearTimeout time-out-id
		time-out-id := setTimeout('$("#global_message").fadeOut(300)',2000)
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

	initial: (json-data)!->
		init-all-data json-data
		tables = new Wrap!

module.exports = main-manage
