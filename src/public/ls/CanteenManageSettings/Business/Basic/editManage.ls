main = null
page = null
edit-manage = let

    _edit-business = null
    _is-one-shown = false

    _block-header-dom = $ '\#basic-edit .block-header'

    _cancel-btn-dom = $ "\#basic-edit .cancel-btn"
    _save-btn-dom = $ "\#basic-edit .save-btn"

    _accept-date-checkbox-dom = $ "\#basic-edit .accept-date-block input[type='checkbox']"
    _pay-method-checkbox-dom = $ "\#basic-edit .pay-method-block input[type='checkbox']"
    _accept-time-list-dom = $ "\#basic-edit .accept-time-list"
    _add-btn-dom = $ "\#basic-edit .add-btn"

    _type-map = {
        "eatin": "堂食",
        "takeaway": "外卖"
        "takeout": "外带",
        "reserve": "预点"
    }

    _tran-time-num-to-arr = (time-num)->
        time-array = []
        time-string = time-num.toString 2
        len = time-string.length
        is-zero = true
        for i from len-1 to 0 by -1
            if (time-string[i] == '1')
                if (is-zero == true)
                    time-array.push len-1-i
                if i == 0
                    time-array.push len-1-i
                else if (i - 1 >= 0) and (time-string[i-1] == '0')
                    time-array.push len-1-i
                is-zero = false
            if (time-string[i] == '0')
                is-zero = true
        time-array


    _tran-time-num-to-strings = (time-num)->
        string-arr = []
        time-array = _tran-time-num-to-arr(time-num)
        len = time-array.length
        if len % 2 == 1
            return
        for i from 0 to len-1 by 2
            string-arr.push _tran-time-num-to-string time-array[i]
            string-arr.push _tran-time-num-to-string time-array[i+1]+1
        string-arr

    _tran-time-num-to-string = (num)->
        t = parse-int num / 2
        if t < 10
            hour = '0' + t.toString!
        else
            hour = t.toString!
        if (num % 2) == 0
            minu = '00'
        else
            minu = '30'
        return hour + ' : ' + minu

    _tran-string-to-time-num = (str)->
        left-part = parse-int str.split(' : ')[0]
        right-part = parse-int str.split(' : ')[1]
        num = left-part*2
        if right-part == 30
            num += 1
        num

    _tran-strings-array = (time-strings)->
        num-arr = []
        for string in time-strings
            num-arr.push (_tran-string-to-time-num string)
        num-arr

    _tran-arr-to-num = (arr)->
        zero-arr = Array(48)
        for i from 0 to zero-arr.length-1 by 1
            zero-arr[i] = '0'
        for i from 0 to arr.length-1 by 2
            start = arr[i]
            end = arr[i+1]-1
            for j from start to end by 1
                zero-arr[j] = '1'
        binary-sting = zero-arr.reverse().join('')
        parse-int binary-sting, 2

    _get-time-strings = ->
        time-strings = []
        time-span-doms = $ '\#basic-edit .time-span'
        for time-span-dom in time-span-doms
            time-strings.push (($ time-span-dom).contents!.get(0).nodeValue)
        time-strings

    _get-able-preiod-time = ->
        num-arr = _tran-strings-array _get-time-strings!
        _tran-arr-to-num num-arr

    _cancel-btn-click-event = !->
        _reset-dom!
        $ '\#auth-link' .show!
        page.toggle-page 'main'

    _save-btn-click-event = !->
        form-data = {}
        form-data.channels = {}
        form-data.able_peroid_week = 0
        # check able_peroid_week
        for checkbox in _accept-date-checkbox-dom
            value = ($ checkbox).val!
            if ($ checkbox).is ":checked"
                form-data.able_peroid_week += parse-int(($ checkbox).val!)
        if form-data.able_peroid_week == 0
            alert "请至少选择一个接单日期"
            return
        # check able_peroid_day
        num-arr = _tran-strings-array _get-time-strings!
        if num-arr.length == 0
            alert "请至少选择一个接单时段"
            return
        for i from 0 to num-arr.length-1 by 2
            if num-arr[i] >= num-arr[i+1]
                alert "接单时段的结束时间应大于开始时间"
                return
            if (num-arr[i] > 48) or (num-arr[i+1] > 48)
                alert "请选择正确的时间" 
                return
        form-data.able_peroid_day = _tran-arr-to-num num-arr
        # check channels
        is-one-chosen = false
        for checkbox in _pay-method-checkbox-dom
            value = ($ checkbox).val!
            if not ($ checkbox).is ':visible'
                continue
            if ($ checkbox).is ":checked"
                form-data.channels[value] = 1
                is-one-chosen = true
            else
                form-data.channels[value] = 0
        if not is-one-chosen
            alert "请至少选择一种支付渠道"
            return
        data = JSON.stringify form-data
        $.ajax {type: "POST", url: "/Dinner/Manage/Firm/Update/"+_edit-business.type, data: data,\
            dataType: "JSON", contentType: "application/json", success: _save-post-success, error: _save-post-fail}
        _set-save-btn-disable!

    _save-post-success = (data)!->
        _set-save-btn-able!
        alert "修改成功", true
        set-timeout (!-> location.reload!), 1000

    _save-post-fail = (error)!->
        _set-save-btn-able!
        alert "请求修改失败"
        set-timeout (!-> location.reload!), 1000

    _set-save-btn-disable = !->
        _save-btn-dom.prop "disabled",true
        _save-btn-dom.add-class "save-btn-disable"

    _set-save-btn-able = !->
        _save-btn-dom.prop "disabled",false
        _save-btn-dom.remove-class "save-btn-disable"

    _checkbox-click-event = (event)!->
        par = ($ event.target).parent!
        if ($ event.target).is ":checked"
            _set-checkbox-checked par
        else
            _set-checkbox-unchecked par

    _set-checkbox-checked = (checkbox-par)!->
        ($ checkbox-par .find "> input[type='checkbox']").attr 'checked',true
        checkbox-par.remove-class "unchecked-icon"
        checkbox-par.add-class "checked-icon"

    _set-checkbox-unchecked = (checkbox-par)!->
        ($ checkbox-par.find "> input[type='checkbox']").attr 'checked',false
        checkbox-par.remove-class "checked-icon"
        checkbox-par.add-class "unchecked-icon"

    _reset-checkebox = !->
        _pay-method-checkbox-dom.each !->
            _set-checkbox-unchecked ($ this).parent!
        _accept-date-checkbox-dom.each !->
            _set-checkbox-unchecked ($ this).parent!

    _reset-dom = !->
        _reset-checkebox!
        time-items = $ '\#basic-edit .accept-time-item'
        for i from 0 to time-items.length-1 by 1
            if i == 0
                continue
            ($ time-items[i]).remove!
        _is-one-shown := false

    _init-accept-date-checkbox-dom = !->
        for checkbox in _accept-date-checkbox-dom
            value = parse-int($ checkbox .val!)
            if (value .&. _edit-business.able_peroid_week) == value
                _set-checkbox-checked ($ checkbox .parent!)

    _init-pay-method-block-dom = !->
        for checkbox in _pay-method-checkbox-dom
            $ checkbox .parent!.hide!
        for method, value of _edit-business.channels
            ($ "input[value='"+method+"']").parent!.show!
            if value == 1
                _set-checkbox-checked ($ "input[value='"+method+"']").parent!

    _init-accept-time-list-dom = !->
        time-strings = _tran-time-num-to-strings _edit-business.able_peroid_day
        len = time-strings.length
        for i from 0 to len-1 by 2
            _insert-accept-time-dom time-strings[i],time-strings[i+1]

    _gene-accept-time-dom = (start-time-string, end-time-string)->
        accept-time-item-dom = $ "<div class='accept-time-item'></div>"
        left-time-item-dom = $ "<span class='time-span'>" + start-time-string + "</span>"
        left-time-item-dom.append _gene-timepicker-dom!
        left-time-item-dom.click (event) !-> _show-timepicker event
        midd-time-item-dom = $ "<span class='context-span'> 至 </span>"
        right-time-item-dom = $ "<span class='time-span'>" + end-time-string + "</span>"
        right-time-item-dom.append _gene-timepicker-dom!
        right-time-item-dom.click (event) !-> _show-timepicker event
        delete-icon-dom = $ "<icon class='delete-icon'></icon>"
        delete-icon-dom.click (event) !-> _delete-accept-time-dom event
        accept-time-item-dom.append left-time-item-dom
        accept-time-item-dom.append midd-time-item-dom
        accept-time-item-dom.append right-time-item-dom
        accept-time-item-dom.append delete-icon-dom

    _insert-accept-time-dom = (start-time-string, end-time-string)!->
        if _is-one-shown
            return
        $ '\#zero-time-item-info' .hide!
        _accept-time-list-dom.append _gene-accept-time-dom start-time-string, end-time-string

    _delete-accept-time-dom = (event)!->
        if _is-one-shown
            return
        target = $ event.target
        while not target.has-class 'accept-time-item'
            target = $ target.parent!
        target.remove!
        time-span-doms = $ '.time-span'
        if time-span-doms.length == 0
            $ '\#zero-time-item-info' .show!

    _show-timepicker = (event)!->
        if _is-one-shown
            return
        target = $ event.target
        while not target.has-class 'time-span'
            target = $ target.parent!
        time-picker-dom = ($ target).find '.time-picker'
        time-picker-dom.attr 'id','shown-timepicker'
        _set-timepicker!
        _is-one-shown := true
        time-picker-dom.fade-in 200

    _hide-timepicker = (event)!->
        if not _is-one-shown
            return
        time-picker-dom = $ "\#shown-timepicker"
        _is-one-shown := false
        time-picker-dom.fade-out 200
        _set-timespan _get-timepicker-value!
        _unset-timepicker!
        time-picker-dom.remove-attr 'id'
        event.stopPropagation!

    _set-timepicker = !->
        time-picker-dom = $ "\#shown-timepicker"
        time-span-dom = time-picker-dom.parent!
        hour-content-dom = time-picker-dom.find '.hour-content'
        minute-content-dom = time-picker-dom.find '.minute-content'
        time-string = time-span-dom.contents!.get(0).nodeValue
        time-string-arr = time-string.split(' : ')
        hour-content-dom.text time-string-arr[0]
        minute-content-dom.text time-string-arr[1]

    _unset-timepicker = !->
        time-picker-dom = $ "\#shown-timepicker"
        hour-content-dom = time-picker-dom.find '.hour-content'
        minute-content-dom = time-picker-dom.find '.minute-content'
        hour-content-dom.text '00'
        minute-content-dom.text '00'

    _get-timepicker-value = ->
        time-picker-dom = $ "\#shown-timepicker"
        hour-content-dom = time-picker-dom.find '.hour-content'
        minute-content-dom = time-picker-dom.find '.minute-content'
        [hour-content-dom.text!, minute-content-dom.text!].join ' : '

    _set-timespan = (time-string)!->
        time-picker-dom = $ "\#shown-timepicker"
        time-span-dom = time-picker-dom.parent!
        time-span-dom.contents!.get(0).nodeValue = time-string

    _gene-timepicker-dom = ->
        time-picker-dom = $ "<div class='time-picker'></div>"
        picker-block-dom = $ "<div class='picker-block'></div>"
        picker-block-dom.append _gene-hour-picker-dom!
        picker-block-dom.append _gene-minute-picker-dom!
        picker-block-dom.append $ "<div class='clear'></div>"
        time-picker-dom.append picker-block-dom
        comfrim-btn-dom = $ "<button class='time-picker-comfirm-btn'>确定</button>"
        comfrim-btn-dom.click (event)!-> _hide-timepicker event 
        time-picker-dom.append comfrim-btn-dom
        time-picker-dom

    _gene-hour-picker-dom = ->
        hour-picker-dom = $ "<div class='hour-picker'></div>"
        hour-picker-dom.append $ "<p class='hour-content'>"+'00'+"</p>"
        upper-btn-dom = $ "<div class='upper-btn'></div>"
        upper-btn-dom.click (event)!-> _hour-upper-btn-click-event event
        hour-picker-dom.append upper-btn-dom
        down-btn-dom = $ "<div class='down-btn'></div>"
        down-btn-dom.click (event)!-> _hour-down-btn-click-event event
        hour-picker-dom.append down-btn-dom
        hour-picker-dom

    _gene-minute-picker-dom = ->
        minute-picker-dom = $ "<div class='minute-picker'></div>"
        minute-picker-dom.append $ "<p class='minute-content'>"+'00'+"</p>"
        upper-btn-dom = $ "<div class='upper-btn'></div>"
        upper-btn-dom.click (event)!-> _minute-upper-btn-click-event event
        minute-picker-dom.append upper-btn-dom
        down-btn-dom = $ "<div class='down-btn'></div>"
        down-btn-dom.click (event)!-> _minute-down-btn-click-event event
        minute-picker-dom.append down-btn-dom
        minute-picker-dom

    _hour-upper-btn-click-event = (event)!->
        target = $ event.target
        while not target.has-class 'hour-picker'
            target = $ target.parent!
        hour-content-dom = target.find '.hour-content'
        hour-content = hour-content-dom.text!
        hour-num = parse-int hour-content
        if hour-num < 24
            hour-num += 1
        if hour-num < 10
            hour-content = '0'+hour-num.toString!
        else
            hour-content = hour-num.toString!
        hour-content-dom.text hour-content

    _hour-down-btn-click-event = (event)!->
        target = $ event.target
        while not target.has-class 'hour-picker'
            target = $ target.parent!
        hour-content-dom = target.find '.hour-content'
        hour-content = hour-content-dom.text!
        hour-num = parse-int hour-content
        if hour-num > 0
            hour-num -= 1
        if hour-num < 10
            hour-content = '0'+hour-num.toString!
        else
            hour-content = hour-num.toString!
        hour-content-dom.text hour-content

    _minute-upper-btn-click-event = (event)!->
        target = $ event.target
        while not target.has-class 'minute-picker'
            target = $ target.parent!
        minute-content-dom = target.find '.minute-content'
        minute-content-dom.text '30'

    _minute-down-btn-click-event = (event)!->
        target = $ event.target
        while not target.has-class 'minute-picker'
            target = $ target.parent!
        minute-content-dom = target.find '.minute-content'
        minute-content-dom.text '00'


    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _add-btn-dom.click !-> _insert-accept-time-dom '00 : 00','00 : 00'
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _pay-method-checkbox-dom.click (event)!-> _checkbox-click-event event
        _accept-date-checkbox-dom.click (event)!-> _checkbox-click-event event

    get-business-and-init: (business, url) !->
        _edit-business := business
        _block-header-dom.text "修改"+_type-map[_edit-business.type]+"业务"
        if _edit-business.type == 'takeaway'
            $ "\#auth-link" .prop 'href', url
        else
            $ "\#auth-link" .hide!
        _init-pay-method-block-dom!
        _init-accept-date-checkbox-dom!
        _init-accept-time-list-dom!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = edit-manage