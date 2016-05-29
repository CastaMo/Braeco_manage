page = refund = print = null
main-manage = let

    _td-water-number-dom = $ ".td-water-number-content"
    _order-details-container-dom = $ ".order-details-container"
    
    _full-cover-dom = $ "\#full-cover"
    _refund-method-container-dom = $ ".refund-method-container"
    
    _type-filter-dom = $ "\#record-order-main .type-filter"
    
    _start-date-input-dom = $ '\#record-order-main .start-date'
    _end-date-input-dom = $ '\#record-order-main .end-date'
    _search-btn-dom = $ "\#record-order-main .search-btn"
    
    _table-body-dom = $ "\.ro-container-table > tbody"
    
    _hover-timer = null
    _leave-timer = null
    
    _type-filter-choose-event = !->
        chosen-value = ($ "\#record-order-main .type-filter option:selected").text!
        tr-doms = $ "\.ro-container-table > tbody > tr"
        if chosen-value === '所有订单'
            for tr in tr-doms
                ($ tr).show!
        else
            for tr in tr-doms
                td-type = ($ tr).find ".td-type"
                if ($ td-type).text! !== chosen-value
                    ($ tr).hide!
                else
                    ($ tr).show!
    
    _search-btn-click-event = !->
        start-date-value = _start-date-input-dom.val!
        end-date-value = _end-date-input-dom.val!
        if start-date-value === ''
            console.log _today-date-to-unix-timestamp!
        else
            start-date = new Date start-date-value
            console.log _date-to-unix-timestamp start-date
        if end-date-value === ''
            console.log _today-date-to-unix-timestamp!
        else
            end-date = new Date end-date-value
            console.log _date-to-unix-timestamp end-date
    
    _tr-hover-event = (event) !->
        target = $ event.target
        while not target.is('tr')
            target = $ target.parent!
        td-water-number = target.find '.td-water-number'
        order-details-container = td-water-number.find '.order-details-container'
        order-details-container.show!
    
    _tr-leave-event = (event) !->
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
    
    _json-data-dom = $ "\#json-data"
    
    _data-obj-array = null
    
    _gene-data-obj-array = !->
        _data-obj-array := $.parseJSON _json-data-dom.text!
    
    _int-to-string =(number)->
        if number > 10
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
            row-dom.append "<td class='table-cat-col'>"+single-food.name+"</td>"
        if single-food.type === 1
            td-name = $ "<td class='table-cat-col'></td>"
            td-name.append $ "<div>"+single-food.name+"</div>"
            for food in single-food.property
                if food instanceof Array
                    for food-item in food
                        td-name.append $ "<div class='sub-food-item'>"+food-item.name+"</div>"
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
        <td class='table-pri-col'>单价</td>
        </tr>
        </thead>"
        table-body-dom = $ "<tbody></tbody>"
        for single-food in content-obj
            if single-food.cat === 0
                continue
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
        for single-promotion in content-obj
            if single-promotion.cat === 0
                promotion-block-dom.append $ "<p>------------------ 优惠 -------------------</p>"
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
       container-dom.append $ "<div class='order-details-header order-details-header-image'>"+data-obj.serial+"</div>"
       order-details-body-dom = $ "<div class='order-details-body'></div>"
       order-details-body-dom.append $ "<p class='order-pay-method'>"+data-obj.channel+"</p>"
       order-details-body-dom.append $ "<p class='order-table'>"+data-obj.table+"</p>"
       
       infomation-dom = $ "<div class='order-infomation info-number'></div>"
       infomation-dom.append $ "<span>No： </span><span>"+data-obj.eaterid_of_dinner+"</span>"
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

       order-details-body-dom.append _gene-food-block-dom data-obj.content
       
       order-details-body-dom.append _gene-promotion-block-dom data-obj.content
       
       order-details-body-dom.append _gene-sum-block-dom data-obj.content, data-obj.price
       
       
       container-dom.append order-details-body-dom
       container-dom


    _gene-tr-dom = (data-obj)->
        tr-dom = $ "<tr></tr>"
        tr-dom.hover !-> (_tr-hover-event event), !-> _tr-leave-event event
        unix-timestamp = parse-int data-obj.create_date
        date = _unix-timestamp-to-date unix-timestamp
        tr-dom.append $ "<td>"+date+"</td>"
        
        tr-dom.append $ "<td>"+data-obj.eaterid_of_dinner+"</td>"
        tr-dom.append $ "<td>"+data-obj.id+"</td>"
        
        td-water-number-dom = $ "<td class='td-water-number'></td>"
        number-content-dom = $ "<p class='td-water-number-content'>"+data-obj.serial+"</p>"
        td-water-number-dom.append number-content-dom
        td-water-number-dom.append _gene-order-details-container data-obj
        tr-dom.append td-water-number-dom
        
        tr-dom.append $ "<td>"+data-obj.price+"元"+"</td>"
        
        tr-dom.append $ "<td class='td-type'>"+data-obj.type+"</td>"
        tr-dom.append $ "<td>"+data-obj.channel+"</td>"
        
        td-methods-dom =  $ "<td class='td-methods'></td>"
        refund-method-container-dom = $ "<div class='method-container'></div>"
        if data-obj.refund === '\u53d1\u8d77\u9000\u6b3e'
            refund-method-container-dom.add-class 'refund-method-container'
            refund-method-container-dom.click !-> _refund-method-container-click-event data-obj
            refund-method-container-dom.append $ "<icon class='refund-icon'></icon>"
            refund-method-container-dom.append $ "<p>退款</p>"
        else
            refund-method-container-dom.append $ "<icon class='refund-disable-icon'></icon>"
            refund-method-container-dom.append $ "<p style='color: #8d8d8d'>退款</p>"
            refund-method-container-dom.append $ "<div class='refund-disable-description'>"+data-obj.refund+"</div>"
            refund-method-container-dom.hover !-> _refund-disable-container-hover-event event
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
        for data-obj in _data-obj-array
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
        _type-filter-dom.change !-> _type-filter-choose-event!


    _init-depend-module = !->
        page 	:= require "./pageManage.js"
        refund  := require "./refundManage.js"
        print   := require "./printManage.js"


    initial: !->
        _gene-data-obj-array!
        for data-obj in _data-obj-array
            _append-row-to-table _gene-tr-dom data-obj
        _gene-type-filter-option!
        _init-depend-module!
        _init-all-event!

module.exports = main-manage