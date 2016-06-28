main-manage = let
    [deep-copy]    =    [util.deep-copy]

    _json-refund-data-dom = $ "\#json-refund-data"
    _json-page-data-dom = $ "\#json-page-data"

    _start-date-input-dom = $ '\#record-refund-main .start-date'
    _end-date-input-dom = $ '\#record-refund-main .end-date'
    _search-btn-dom = $ "\#record-refund-main .search-btn"
    _export-form-dom = $ "\#record-refund-main \#export-form"
    _export-form-st-dom = $ "\#record-refund-main \#export-form-st"
    _export-form-en-dom = $ "\#record-refund-main \#export-form-en"
    _export-btn-dom = $ "\#record-refund-main .export-btn"

    _pre-page-url-dom = $ ".rr-container-paginate .pre-page-url"
    _current-page-dom = $ ".rr-container-paginate .current-page"
    _total-page-dom = $ ".rr-container-paginate .total-page"
    _next-page-url-dom = $ ".rr-container-paginate .next-page-url"
    _target-page-input-dom = $ ".rr-container-paginate .target-page-input"
    _jump-btn-dom = $ ".rr-container-paginate .jump-btn"

    _table-body-dom = $ ".rr-container-table > tbody"

    _page-data-obj = null

    _int-to-string =(number)->
        if number >= 10
            number.to-string!
        else
            "0"+number.to-string!

    _unix-timestamp-to-date = (timestamp)->
        d = new Date timestamp*1000
        year = d.get-full-year!.to-string!
        month = _int-to-string d.get-month!+1
        date = _int-to-string d.get-date!
        hour = _int-to-string d.get-hours!
        minute = _int-to-string d.get-minutes!
        second = _int-to-string d.get-seconds!
        year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second
    
    _unix-timestamp-to-only-date = (timestamp)->
        d = new Date timestamp*1000
        year = d.get-full-year!.to-string!
        month = _int-to-string d.get-month!+1
        date = _int-to-string d.get-date!
        year+"-"+month+"-"+date

    _date-to-unix-timestamp = (date)->
        date.get-time! / 1000

    _construct-url = (st,en,pn,type)->
        if st === null
            st = ''
        if en === null
            en = ''
        "/Manage/Data/Record/Refund?st="+st+"&en="+en+"&pn="+pn

    _search-btn-click-event = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = 1
        location.href = _construct-url st,en,pn

    _export-btn-click-event = !->
        _export-form-st-dom.val _page-data-obj.st
        _export-form-en-dom.val _page-data-obj.en

    _jump-btn-click-event = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = parse-int _target-page-input-dom.val!
        location.href = _construct-url st,en,pn

    _start-date-input-dom-change-event = !->
        start-date = _start-date-input-dom.val!
        _page-data-obj.st = _date-to-unix-timestamp new Date start-date
    
    _end-date-input-dom-change-event = !->
        end-date = _end-date-input-dom.val!
        _page-data-obj.en = _date-to-unix-timestamp new Date end-date
        _page-data-obj.en = _page-data-obj.en+24*3600-1

    class Refund
        (refund) ->
            deep-copy refund, @
            @gene-tr-dom!

        unix-timestamp-to-date: (timestamp)->
            d = new Date timestamp*1000
            year = d.get-full-year!.to-string!
            month = _int-to-string d.get-month!+1
            date = _int-to-string d.get-date!
            hour = _int-to-string d.get-hours!
            minute = _int-to-string d.get-minutes!
            second = _int-to-string d.get-seconds!
            year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second

        gene-tr-dom: !->
            tr-dom = $ "<tr></tr>"
            date-string = @unix-timestamp-to-date @.start_time
            tr-dom.append $ "<td>"+date-string+"</td>"
            tr-dom.append $ "<td>"+@.order+"</td>"
            tr-dom.append @gene-refund-items-dom!
            tr-dom.append $ "<td>"+@.amount+"</td>"
            tr-dom.append $ "<td>"+@.channel+"</td>"
            tr-dom.append $ "<td>"+@.description+"</td>"
            _table-body-dom.append tr-dom

        gene-refund-items-dom: ->
            td-dom = $ "<td class='refund-items'></td>"
            for content in @.content
                refund-item-dom = $ "<div class='refund-item'></div>"
                refund-item-dom.append $ "<span class='refund-item-name'>"+content.name+"</span>"
                refund-item-dom.append $ "<span class='refund-item-sum'> × "+content.sum+"</span>"
                td-dom.append refund-item-dom
            td-dom

    _gene-data = !->
        _refund-data-obj-array = $.parseJSON _json-refund-data-dom.text!
        _page-data-obj := $.parseJSON _json-page-data-dom.text!
        for refund in _refund-data-obj-array
            console.log refund_
            refund_ = new Refund refund

    _init-datepicker = !->
        $.fn.datepicker.languages['zh-CN'] = {
            days: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
            daysShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
            daysMin: ['日', '一', '二', '三', '四', '五', '六'],
            months: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
            monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
            weekStart: 1,
            startView: 0,
            yearFirst: true,
            yearSuffix: '年'
        }
        $('[data-toggle="datepicker"]').datepicker {format: 'yyyy-mm-dd', language: 'zh-CN', autohide: true}

    _init-page-info = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = parse-int _page-data-obj.pn
        if st === null
            st := _page-data-obj.today
        if en === null
            en := _page-data-obj.today + 24*3600-1
        else
            en := en + 24*3600-1
        _start-date-input-dom.val _unix-timestamp-to-only-date st
        _end-date-input-dom.val _unix-timestamp-to-only-date en
        _current-page-dom.text pn.to-string!
        _total-page-dom.text _page-data-obj.sum_pages.to-string!
        _target-page-input-dom.val pn
        if pn > 1
            pre-pn = pn-1
        else
            pre-pn = pn
        _pre-page-url-dom.attr 'href', _construct-url _page-data-obj.st,_page-data-obj.en,pre-pn
        if pn < _page-data-obj.sum_pages
            next-pn = pn+1
        else
            next-pn = pn
        _next-page-url-dom.attr 'href', _construct-url _page-data-obj.st,_page-data-obj.en,next-pn

    _init-all-event = !->
        _search-btn-dom.click !-> _search-btn-click-event!
        _export-btn-dom.click !-> _export-btn-click-event!
        _jump-btn-dom.click !-> _jump-btn-click-event!
        _start-date-input-dom.change !-> _start-date-input-dom-change-event!
        _end-date-input-dom.change !-> _end-date-input-dom-change-event!

    initial: !->
        _gene-data!
        _init-datepicker!
        _init-all-event!
        _init-page-info!

module.exports = main-manage