do !->
	Init-date = (dates)!->
		dates = $ dates
		for temp, i in dates
			$(temp).datepicker({
				autohide: true
				format: 'yyyy-mm-dd'
				startDate: new Date(2015, 5, 1)
				endDate: new Date()
				trigger: $('.mypicker').get(i)
				setDate: new Date(2016, 4, 5)
				days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
				daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
				daysMin: ["日", "一", "二", "三", "四", "五", "六"]
				months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
				monthsShort: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
				yearSuffix: "年"
				weekStart: 1,
				startView: 0,
				yearFirst: true,
			})

	Init-page = (table,pages) !->
		@tables = JSON.parse ($ '#json-field' ).text!
		@pages = JSON.parse ($ '#page-JSON-field' ).text!

		$ '#search' .click !->
			window.location.href = _get-url _get-url-data!
		$ 'select[name=type]' .change !->
			window.location.href = _get-url _get-url-data!
		$ 'input[name=jump]' .keyup (e)->
			if e && e.keyCode == 13
				_page-jump!
		$ '.page_jump' .click ->
			_page-jump!

		_page-jump =->
			t = $ 'input[name=jump]' .val!
			curr = parseInt($ '.page_text span' .eq 1 .text!)
			console.log t,curr
			if a =='' || /\s/.test(a)
				return alert '请输入跳转的页码'
			else if parseInt(t)> curr
				alert '当前数据只有 <b>'+curr+'</b> 页哦！'
			else
				a = _get-url-data!
				a.pn = t
				window.location.href = _get-url a
		_fill-page-num =!~>
			$ 'select[name=type]' .val @pages.type
			$ '.page_text span' .eq(0).text(@pages.pn)
			$ '.page_text span' .eq(1).text(@pages.sum_pages)
			if parseInt(@pages.pn) <=1
				$ '#page .left' .removeAttr 'href'
			else 
				a = _get-url-data!
				a.pn = parseInt(@pages.pn)-1
				$ '#page .left' .attr('href',_get-url a )
			if parseInt(@pages.pn)>= parseInt(@pages.sum_pages)
				$ '#page .right' .removeAttr 'href'
			else 
				a = _get-url-data!
				a.pn = parseInt(@pages.pn)+1
				$ '#page .right' .attr('href',_get-url a)

		_fill-table = !~>
			body = $ '.center tbody' .empty!
			for temp in @tables
				newtr = $ '<tr>'
				newtr.append '<td>'+ (_unix-to-date temp.time)+'</td>'
				newtr.append '<td>'+ temp.executor+'</td>'
				newtr.append '<td>'+ temp.msg+'</td>'
				newtr.append '<td>'+ temp.type+'</td>'
				body.append newtr
		_fill-date-input = (ob,t)!->
			if(t)
				ob.val(_unix-to-date t )
			else
				ob.val(new Date().Format('yyyy-MM-dd'))
		_unix-to-date  = (time)->
			time = parseInt(time) + 8 * 60 * 60;
			time = new Date time * 1000 
			ymdhis = time.getUTCFullYear! + "-"
			ymdhis += _add-zero(time.getUTCMonth!+1) + "-"
			ymdhis += _add-zero time.getUTCDate! 
			ymdhis
		_date-to-unix = (d,add)->
			if d == ''
				return ''
			if add ==1
				return ((new Date d ).getTime!)/1000 + 3600*24-1
			return (new Date d ).getTime!/1000

		_add-zero = (x)->
			x>=10 ? x : ('0'+x)
			x
		_get-url-data = ->
			st = _date-to-unix($ 'input[name=st]' .val!)
			en =  _date-to-unix($ 'input[name=en]' .val!,1)
			if(st!='' && en!=''&&st>=en)
				return alert '日期选择框的开始时间不可以大于结束时间哦！'
			a = 
				st : st
				en : en
				type : $ 'select[name=type]' .val!
		_get-url = (x)->
			a = ''
			for key,val of x
				a += '&'+key + '=' +val
			a = '?' + a.substr(1)
		do _fill = !~>
			setDate = new Init-date 'input.time',_unix-to-date(@pages.register_time)
			_fill-table!
			_fill-page-num!

	setPage = new Init-page!
