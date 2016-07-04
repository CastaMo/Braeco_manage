page = refund = print = null
main-manage = let

    _td-water-number-dom = $ ".td-water-number-content"
    _order-details-container-dom = $ ".order-details-container"
    
    _full-cover-dom = $ "\#full-cover"
    _refund-method-container-dom = $ ".refund-method-container"
    
    _type-filter-dom = $ "\#record-order-main .type-filter"
    
    _start-datepicker-dom = $ '\#record-order-main .start-datepicker-field'
    _end-datepicker-dom = $ '\#record-order-main .end-datepicker-field'
    _start-date-input-dom = $ '\#record-order-main .start-date'
    _end-date-input-dom = $ '\#record-order-main .end-date'
    _search-btn-dom = $ "\#record-order-main .search-btn"
    _export-form-dom = $ "\#record-order-main \#export-form"
    _export-form-class-dom = $ "\#record-order-main \#export-form-class"
    _export-form-st-dom = $ "\#record-order-main \#export-form-st"
    _export-form-en-dom = $ "\#record-order-main \#export-form-en"
    _export-form-type-dom = $ "\#record-order-main \#export-form-type"
    _export-btn-dom = $ "\#record-order-main .export-btn"
    
    _pre-page-url-dom = $ ".ro-container-paginate .pre-page-url"
    _current-page-dom = $ ".ro-container-paginate .current-page"
    _total-page-dom = $ ".ro-container-paginate .total-page"
    _next-page-url-dom = $ ".ro-container-paginate .next-page-url"
    _target-page-input-dom = $ ".ro-container-paginate .target-page-input"
    _jump-btn-dom = $ ".ro-container-paginate .jump-btn"
    
    _table-body-dom = $ "\.ro-container-table > tbody"
    
    _hover-timer = null
    _leave-timer = null

    _is-one-pinned = false
    
    _construct-url = (st,en,pn,type)->
        if st === null
            st = ''
        if en === null
            en = ''
        "/Manage/Data/Record/Order?st="+st+"&en="+en+"&pn="+pn+"&type="+type
    
    _type-filter-choose-event = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = 1
        type = _type-filter-dom.val!
        location.href = _construct-url st,en,pn,type
    
    _search-btn-click-event = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = 1
        type = _type-filter-dom.val!
        location.href = _construct-url st,en,pn,type
    
    _export-btn-click-event = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        if st === null
            st = _page-data-obj.today
        else
            st = _page-data-obj.st
        if en === null
            en = _page-data-obj.today + 24*3600-1
        else
            en = _page-data-obj.en
        _export-form-type-dom.val _type-filter-dom.val!
        _export-form-st-dom.val st
        _export-form-en-dom.val en
        
    _jump-btn-click-event = !->
        st = _page-data-obj.old-st
        en = _page-data-obj.old-en
        type = _page-data-obj.type
        pn = parse-int _target-page-input-dom.val!
        location.href = _construct-url st,en,pn,type
    
    _start-date-input-dom-change-event = !->
        start-date = _start-date-input-dom.val!
        _page-data-obj.st = _date-to-unix-timestamp new Date start-date
        _page-data-obj.st = _page-data-obj.st-8*3600
    
    _end-date-input-dom-change-event = !->
        end-date = _end-date-input-dom.val!
        _page-data-obj.en = _date-to-unix-timestamp new Date end-date
        _page-data-obj.en = _page-data-obj.en-8*3600+24*3600-1

    _tr-hover-event = (event) !->
        if _is-one-pinned
            return
        target = $ event.target
        while not target.is('tr')
            target = $ target.parent!
        td-water-number = target.find '.td-water-number'
        order-details-container = td-water-number.find '.order-details-container'
        order-details-container.show!
    
    _tr-leave-event = (event) !->
        if _is-one-pinned
            return
        target = $ event.target
        while not target.is('tr')
            target = $ target.parent!
        td-water-number = target.find '.td-water-number'
        order-details-container = td-water-number.find '.order-details-container'
        order-details-container.hide!
    
    _refund-method-container-click-event = (data-obj) !->
        refund.initial-refund-page data-obj
        _full-cover-dom.fade-in 100
    
    _print-method-container-click-event = (order-id)!->
        print.initial-print-page order-id
        _full-cover-dom.fade-in 100
        
    _refund-disable-container-hover-event = (event)!->
        target = $ event.target
        description-dom = target.parent!.find ".refund-disable-description"
        if description-dom.is ':hidden'
            description-dom.fade-in 100
        else
            description-dom.fade-out 100
    
    _json-order-data-dom = $ "\#json-order-data"
    _json-page-data-dom = $ "\#json-page-data"
    
    _order-data-obj-array = null
    _page-data-obj = null
    
    _gene-data = !->
        _order-data-obj-array := $.parseJSON _json-order-data-dom.text!
        _page-data-obj := $.parseJSON _json-page-data-dom.text!
    
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
    
    _today-date-to-unix-timestamp = ->
        d = new Date!
        year = d.get-full-year!.to-string!
        month = _int-to-string d.get-month!+1
        date = _int-to-string d.get-date!
        new_date = new Date year+"-"+month+"-"+date
        new_date.get-time! / 1000

    _gene-food-table-row = (single-food) ->
        row-dom = $ "<tr></tr>"
        if single-food.type === 0
            td-name = $ "<td class='table-cat-col'>"+single-food.name+"</td>"
            if single-food.property.length > 0
                td-name.append $ "<span class='sub-food-item'>"+'（'+(single-food.property.join '、')+"）"+"</span>"
            row-dom.append td-name
        if single-food.type === 1
            td-name = $ "<td class='table-cat-col'>"+single-food.name+"</td>"
            for food in single-food.property
                if food instanceof Array and food.length === 1 and food[0].name === '属性'
                    td-name.append $ "<span class='sub-food-item'>"+'（'+(food[0].p.join '、')+"）"+"</span>"
            for food in single-food.property
                if food instanceof Array
                    if food.length === 1 and food[0].name === '属性'
                        continue
                    for food-item in food
                        if food-item.p.length === 0
                            td-name.append $ "<div class='sub-food-item'>"+food-item.name+"</div>"
                        else
                            td-name.append $ "<div class='sub-food-item'>"+food-item.name+"<span>"+'（'+(food-item.p.join '、')+"）"+"</span>"+"</div>"
                            
            row-dom.append td-name
        row-dom.append "<td class='table-num-col'>"+single-food.sum+"</td>"
        row-dom.append "<td class='table-pri-col'>"+single-food.price+"</td>"
        $ row-dom
    
   
    _gene-order-food-table = (content-obj) ->
        table-dom = $ "<table class='order-food-table'></table>"
        table-dom.append $ "<thead>
        <tr>
        <td class='table-cat-col'>项目</td>
        <td class='table-num-col'>数量</td>
        <td class='table-pri-col'>单价（元）</td>
        </tr>
        </thead>"
        table-body-dom = $ "<tbody></tbody>"
        current-cat = 0
        for single-food in content-obj
            if single-food.cat === 0
                continue
            if current-cat !== 0 and current-cat !== single-food.cat
                table-body-dom.append "<tr><td colspan='3'>-----------------------------------------</td></tr>"
            current-cat := single-food.cat
            table-body-dom.append _gene-food-table-row single-food
        table-dom.append table-body-dom
        $ table-dom

    _gene-food-block-dom = (content-obj) ->
        food-block-dom = $ "<div class='details-block'></div>"
        food-block-dom.append "<p>------------------ 餐品 -------------------</p>"
        food-block-dom.append _gene-order-food-table content-obj
        $ food-block-dom
        
    
    _gene-promotion-block-dom = (content-obj) ->
        promotion-block-dom = $ "<div class='details-block'></div>"
        first-promition = true
        for single-promotion in content-obj
            if single-promotion.cat === 0
                if first-promition
                    promotion-block-dom.append $ "<p>------------------ 优惠 -------------------</p>"
                    first-promition = false
                promotion-block-dom.append $ "<span class='left-span'>"+single-promotion.name+"</span>"
                promotion-block-dom.append $ "<span class='right-span'>"+single-promotion.property[0]+"</span>"
                promotion-block-dom.append "<div class='clear'></div>"
        $ promotion-block-dom
    
    _gene-sum-block-dom = (content-obj, price) ->
       sum-block-dom = $ "<div class='details-block'></div>"
       sum-block-dom.append "<p>------------------ 总计 -------------------</p>"
       sum = _get-food-number-sum content-obj
       sum-block-dom.append "<span class='left-span'>餐品数："+sum.to-string!+"</span>"
       sum-block-dom.append "<span class='right-span'>总价："+price+"</span>"
       sum-block-dom.append "<div class='clear'></div>"
       $ sum-block-dom

    _get-food-number-sum = (content-obj) ->
        sum = 0
        for single-food in content-obj
            if single-food.cat === 0
                continue
            sum += single-food.sum
        sum
    
    _gene-order-details-container =(data-obj)->
        container-dom = $ "<div class='order-details-container'></div>"
        if data-obj.serial === '推送失败'
            order-details-header-dom = $ "<div class='order-details-header order-details-header-image'><p>"+"接单失败"+
            "</p></div>"
        else
            order-details-header-dom = $ "<div class='order-details-header order-details-header-image'><p>"+data-obj.serial+
            "</p></div>"
        pin-icon-dom = "<icon class='pin-icon unpinned-icon'></icon>"
        order-details-header-dom.append pin-icon-dom
        container-dom.append order-details-header-dom
        order-details-body-dom = $ "<div class='order-details-body'></div>"
        order-details-body-dom.append $ "<p class='order-pay-method'>"+data-obj.channel+"</p>"
        if (parse-int data-obj.table) === NaN
            order-details-body-dom.append $ "<p class='order-table'>"+data-obj.table+"</p>"
        else
            order-details-body-dom.append $ "<p class='order-table'>"+data-obj.table+"号桌</p>"
       
        infomation-dom = $ "<div class='order-infomation info-number'></div>"
        if data-obj.eaterid_of_dinner === null
            infomation-dom.append $ "<span>会员编号： </span><span>"+'-'+"</span>"
        else
            infomation-dom.append $ "<span>会员编号： </span><span>"+data-obj.eaterid_of_dinner+"</span>"
        order-details-body-dom.append infomation-dom
        
        if data-obj.phone !== '-'
            infomation-dom = $ "<div class='order-infomation info-phone'></div>"
            infomation-dom.append $ "<span>手机号码： </span><span>"+data-obj.phone+"</span>"
            order-details-body-dom.append infomation-dom
        
        infomation-dom = $ "<div class='order-infomation info-order-pay-time'></div>"
        unix-timestamp = parse-int data-obj.create_date
        date = _unix-timestamp-to-date unix-timestamp
        infomation-dom.append $ "<span>成交时间： </span><span>"+date+"</span>"
        order-details-body-dom.append infomation-dom
        
        infomation-dom = $ "<div class='order-infomation info-order-number'></div>"
        infomation-dom.append $ "<span>订单号： </span>"
        infomation-dom.append $ "<span>"+data-obj.id+"</span>"
        order-details-body-dom.append infomation-dom

        if data-obj.describtion !== null
            infomation-dom = $ "<div class='order-infomation'></div>"
            infomation-dom.append $ "<span>备注： </span>"
            infomation-dom.append $ "<span>"+data-obj.describtion+"</span>"
            order-details-body-dom.append infomation-dom

        order-details-body-dom.append _gene-food-block-dom data-obj.content

        order-details-body-dom.append _gene-promotion-block-dom data-obj.content
       
        order-details-body-dom.append _gene-sum-block-dom data-obj.content, data-obj.price

        container-dom.append order-details-body-dom
        container-dom.click (event)!-> _order-details-container-click-event event
        container-dom

    _tr-click-event = (event) !->
        if _is-one-pinned
            return
        target = $ event.target
        while not target.is 'tr'
            target = $ target.parent!
        td-water-number = target.find '.td-water-number'
        container-dom = td-water-number.find '.order-details-container'
        icon = container-dom.find ".order-details-header .pin-icon"
        icon.remove-class 'unpinned-icon'
        icon.add-class 'pinned-icon'
        _is-one-pinned := true
        container-dom.attr "id","pinned-order-container"
        event.stop-propagation!

    _order-details-container-click-event = (event)!->
        # target = $ event.target
        # while not target.has-class 'order-details-container'
        #     target = $ target.parent!
        # container-dom = target
        # target = $ event.target
        # if target.is "icon" and target.has-class "pin-icon"
        #     if _is-one-pinned
        #         target.remove-class 'pinned-icon'
        #         target.add-class 'unpinned-icon'
        #         container-dom.remove-attr 'id'
        #         _is-one-pinned := false
        #         return
        # icon = container-dom.find ".order-details-header .pin-icon"
        # icon.remove-class 'unpinned-icon'
        # icon.add-class 'pinned-icon'
        # _is-one-pinned := true
        # container-dom.attr "id","pinned-order-container"

    _html-click-event = (event)!->
        if _is-one-pinned === false
            return
        target = $ event.target
        is-outside = true
        while (not target.is 'html') and _is-one-pinned
            if (target.attr 'id') === 'pinned-order-container'
                is-outside := false
            target = target.parent!
        if is-outside
            pinned-container-dom = $ "\#pinned-order-container"
            icon = pinned-container-dom.find ".order-details-header .pin-icon"
            icon.remove-class 'pinned-icon'
            icon.add-class 'unpinned-icon'
            pinned-container-dom.hide!
            _is-one-pinned := false
            pinned-container-dom.remove-attr "id"
            target = $ event.target
            while not target.is 'html'
                if target.is 'tr' and target.parent!.is 'tbody'
                    target.trigger 'mouseenter'
                    break
                target = target.parent!
        else
            target = $ event.target
            while not target.has-class 'order-details-container'
                target = $ target.parent!
            container-dom = target
            target = $ event.target
            if target.is "icon" and target.has-class "pin-icon"
                target.remove-class 'pinned-icon'
                target.add-class 'unpinned-icon'
                _is-one-pinned := false
                container-dom.remove-attr 'id'

    _gene-tr-dom = (data-obj)->
        tr-dom = $ "<tr></tr>"
        tr-dom.hover ((event)!-> _tr-hover-event event), ((event)!-> _tr-leave-event event)
        tr-dom.click (event)!-> _tr-click-event event
        unix-timestamp = parse-int data-obj.create_date
        date = _unix-timestamp-to-date unix-timestamp
        tr-dom.append $ "<td>"+date+"</td>"
        
        if data-obj.eaterid_of_dinner === null
            tr-dom.append $ "<td>"+"-"+"</td>"
        else
            tr-dom.append $ "<td>"+data-obj.eaterid_of_dinner+"</td>"
        tr-dom.append $ "<td>"+data-obj.id+"</td>"
        
        td-water-number-dom = $ "<td class='td-water-number'></td>"
        if data-obj.serial === '推送失败'
            number-content-dom = $ "<p class='td-water-number-content'>"+"接单失败"+"</p>"
        else
            number-content-dom = $ "<p class='td-water-number-content'>"+data-obj.serial+"</p>"
        td-water-number-dom.append number-content-dom
        td-water-number-dom.append _gene-order-details-container data-obj
        tr-dom.append td-water-number-dom
        
        tr-dom.append $ "<td>"+data-obj.price+"元"+"</td>"
        
        tr-dom.append $ "<td class='td-type'>"+data-obj.type+"</td>"
        tr-dom.append $ "<td>"+data-obj.channel+"</td>"
        
        td-methods-dom =  $ "<td class='td-methods'></td>"
        refund-method-container-dom = $ "<div class='method-container'></div>"
        if data-obj.refund === '发起退款'
            refund-method-container-dom.add-class 'refund-method-container'
            refund-method-container-dom.append $ "<icon class='refund-icon'></icon>"
            refund-method-container-dom.append $ "<p>退款</p>"
            refund-method-container-dom.click !-> _refund-method-container-click-event data-obj
        else
            refund-method-container-dom.append $ "<icon class='refund-disable-icon'></icon>"
            refund-method-container-dom.append $ "<p class='refund-disable-word'>退款</p>"
            refund-method-container-dom.append $ "<div class='refund-disable-description'><p>"+data-obj.refund+"</p></div>"
            $(refund-method-container-dom.find "icon").hover (event)!-> _refund-disable-container-hover-event event
        td-methods-dom.append refund-method-container-dom
        print-method-container-dom = $ "<div class='method-container'>
        <icon class='print-icon'></icon>
        <p>打印</p>
        </div>"
        print-method-container-dom.click !-> _print-method-container-click-event data-obj.id
        td-methods-dom.append print-method-container-dom
        td-methods-dom.append "<div class='clear'></div>"
        tr-dom.append td-methods-dom
        $ tr-dom

    _get-all-types = ->
        types-array = []
        for data-obj in _order-data-obj-array
            is-exit = false
            for type in types-array
                if type == data-obj.type
                    is-exit := true
                    break
            if not is-exit
                types-array.push data-obj.type
        types-array

    _gene-type-filter-option = !->
        types-array = _get-all-types!
        _type-filter-dom.append $ "<option value='所有订单'>所有订单</option>"
        for type in types-array
            _type-filter-dom.append $ "<option value='"+type+"'>"+type+"</option>"

    _append-row-to-table = (tr-dom)!->
        _table-body-dom.append tr-dom

    
    _init-all-event = !->
        _search-btn-dom.click !-> _search-btn-click-event!
        _export-btn-dom.click !-> _export-btn-click-event!
        _type-filter-dom.change !-> _type-filter-choose-event!
        _jump-btn-dom.click !-> _jump-btn-click-event!
        _start-date-input-dom.change !-> _start-date-input-dom-change-event!
        _end-date-input-dom.change !-> _end-date-input-dom-change-event!
        ($ "html").click (event)!-> _html-click-event event

    _init-page-info = !->
        st = _page-data-obj.st
        en = _page-data-obj.en
        pn = parse-int _page-data-obj.pn
        type = _page-data-obj.type
        if en !== null
            en := en + 24*3600-1
            _page-data-obj.en = en
        _page-data-obj.old-en = _page-data-obj.en
        _page-data-obj.old-st = _page-data-obj.st
        
        if st !== null
            _start-date-input-dom.val _unix-timestamp-to-only-date st
        if en !== null
            _end-date-input-dom.val _unix-timestamp-to-only-date en
        _type-filter-dom.val type
        _current-page-dom.text pn.to-string!
        _total-page-dom.text _page-data-obj.sum_pages.to-string!
        _target-page-input-dom.val pn
        if pn > 1
            pre-pn = pn-1
        else
            pre-pn = pn
        _pre-page-url-dom.attr 'href', _construct-url _page-data-obj.st,_page-data-obj.en,pre-pn,type
        if pn < _page-data-obj.sum_pages
            next-pn = pn+1
        else
            next-pn = pn
        _next-page-url-dom.attr 'href', _construct-url _page-data-obj.st,_page-data-obj.en,next-pn,type

    _init-depend-module = !->
        page 	:= require "./pageManage.js"
        refund  := require "./refundManage.js"
        print   := require "./printManage.js"


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
        _start-date-input-dom.datepicker {format: 'yyyy-mm-dd', language: 'zh-CN', autohide: true, trigger: _start-datepicker-dom}
        _end-date-input-dom.datepicker {format: 'yyyy-mm-dd', language: 'zh-CN', autohide: true, trigger: _end-datepicker-dom}

    initial: !->
        _gene-data!
        for data-obj in _order-data-obj-array
            _append-row-to-table _gene-tr-dom data-obj
        _init-datepicker!
        _init-all-event!
        _init-depend-module!
        _init-page-info!
        

module.exports = main-manage