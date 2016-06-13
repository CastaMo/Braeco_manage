do !->
	_init-date = (dates)!->
		dates = $ dates
		for temp, i in dates
			$(temp).val(new Date().Format('yyyy-MM-dd'))
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
	_init-table = (table)!->
		unix-to-date  = (time)->
			time = parseInt(time) + 8 * 60 * 60;
			time = new Date time * 1000 
			ymdhis = time.getUTCFullYear! + "-"
			ymdhis += addZero(time.getUTCMonth!+1) + "-"
			ymdhis += addZero time.getUTCDate! 
			ymdhis += "<br> " + addZero(time.getUTCHours!)+":"
			ymdhis += addZero(time.getUTCMinutes!)+":"
			ymdhis += addZero time.getUTCSeconds!
			ymdhis
		addZero = (x)->
			x>=10 ? x : ('0'+x)
			x
		# console.log(JSON.stringify table )
		do (mytable = table)!->
			body = $ '.center tbody' .empty!
			for temp in mytable
				newtr = $ '<tr>'
				newtr.append '<td>'+ (unix-to-date temp.time)+'</td>'
				newtr.append '<td>'+ temp.executor+'</td>'
				newtr.append '<td>'+ temp.msg+'</td>'
				newtr.append '<td>'+ temp.type+'</td>'
				body.append newtr

	setTable = new _init-table JSON.parse ($ '#json-field' ).text!
	setDate = new _init-date 'input.time'