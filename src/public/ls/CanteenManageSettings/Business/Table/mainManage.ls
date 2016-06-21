main-manage = let
	Tables = !->
		tables = []
		operations = []
		time-out-id = ''
		for x in $ '.table_qr:not(.add_new)' 
			tables.push(new Table x )
		for x in $ '.table_operation'
			operations.push(new Operation x)
		add-table = new Add-new($ '.table_qr.add_new' .get 0)

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
						case 4  then  show-wrap 0,4
					else
						show-global-message '要先点击选择桌位哦！'
		$ '.wrap' .find '.btn.cancle' .click !->
			close-wrap(0,$ @ .parents '.wrap' .index!)
		$ '.popup' .find '.btn.cancle' .click !->
			dom = $ @ .parents '.popup'
			if dom.hasClass 'edit'
				close-wrap 1,dom.get(0),'edit'
			else if dom.hasClass 'delete'
				close-wrap 1,dom.get(0),'delete'
		$ '.imgli' .click ->
			$ '.imgli' .removeClass 'selected'
			$ @ .addClass 'selected'
		$ '.wrap.batch_export1 .confirm' .click !->
			i = $ '.imgli.selected' .index!
			if i>=0
				if i == 0
					show-wrap 0,3
				else
					show-wrap 0,2,i
			else
				show-global-message '要先点击选择模板哦！'
		select_all = (flag)!->
			for x in tables
				x.prototype.change-click-state flag 
		# i = 0 : arg1表示wrap的下标
		# i = 1 : arg1表示 table_tr 的dom，arg2 表示'edit'或者'delete'
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
					wrap.attr('type',arr[arg2+1])
					wrap.find 'input' .val ''
					wrap.find 'select' .val ''
					wrap.find '.wrap_right img' .attr('src',$ '.batch_export1 .imgli.selected img' .attr 'src' )
			case 1 then
				$ '#popup_cover' .show!
				little-wrap = $ arg1 .find arg2
				if(arg2 == '.edit')
					little-wrap.find 'input' .val($ arg1 .find '.num' .text!)
				little-wrap.fadeIn 300

		# i = 0 : arg1表示wrap的下标
		# i = 1 : arg1表示 popup 的dom
		close-wrap = (i,arg1)!->
			switch i 
			case 0 then
				$ '#wrap' .fadeOut 300
				$ '.wrap' .eq(arg1).hide!
			case 1 then
				$ arg1 .fadeOut 300
				$ '#popup_cover' .hide!
		# 显示全局信息提示
		show-global-message = (str)->
			ob = $ '#global_message' 
			ob.show!
			ob.html str 
			clearTimeout time-out-id
			time-out-id := setTimeout('$("#global_message").fadeOut(300)',2000)
			
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
			console.log ob1,ob2,flag
			if(ob2)
				ob2.show!
			if flag == '0'
				ob1.show!
			else if flag == '1'
				ob1.hide!
			else if flag == '2'
				ob2.hide!
		# 获取qrcode的数据
		get-qrcode-data = ->
			objs = $ '.table_qr.disabled'
			mydata = get-select-val!
			arr=[]
			for temp in objs
				arr.push $ temp .find '.num' .text!
			mydata.content = arr
			mydata.wifi_name = $ '.batch_export2 input[name=wifi_name]:visible' .val!
			mydata.wifi_password = $ '.batch_export2 input[name=wifi_password]:visible' .val!
			mydata.email = $ '.batch_export2 input[name=wifi_email]:visible:visible' .val!
			mydata.type = $ '.batch_export2 .add_wifi_model' .attr 'qrcode_type'
			mydata
		get-select-val = ->
			mydata = {}
			mydata.a = $ '.batch_export2 select[name=wifi]:visible' .val!
			mydata.b = $ '.batch_export2 select[name=pay]:visible' .val!
			mydata.c = $ '.batch_export2 select[name=discount]:visible' .val!
			mydata

	Operation = (op)->
		@.prototype = new Change-state op
		that = @.prototype

	Table = (t)->
		@.prototype = new Change-state t
		that = @.prototype
		$ that.dom .click !~>			
			that.change-click-state!
		$ that.dom .find '.popup' .click ->
			return false
		$ that.dom .find '.popup .btn.cancle' .click !~>
			that.change-click-state true 
		@
	Add-new = (t)!->
		@.prototype = new Table t
		$ @.prototype.dom .click !->

	Change-state = (ob)->
		@.able = !$ ob .hasClass 'disabled'
		@.dom = ob
		@.change-click-state = (state)!~>
			if state!=undefined
				@.able = state
			else
				@able = !@able
			if @.able
				$ @.dom .removeClass 'disabled'
			else 
				$ @.dom .addClass 'disabled'
		@
	initial: !->
		# _save-form-value!
		tables = new Tables!

module.exports = main-manage
