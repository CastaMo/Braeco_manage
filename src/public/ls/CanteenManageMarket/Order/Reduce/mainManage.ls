page = null
edit = null
main-manage = let

    _reduce-start-btn-dom = $ "\#order-reduce-main .reduce-start-btn"
    _reduce-stop-btn-dom = $ "\#order-reduce-main .reduce-stop-btn"
    _edit-btn-dom = $ "\#order-reduce-main .edit-btn"

    _start-alert-block-dom = $ "\#start-alert-block"
    _stop-alert-block-dom = $ "\#stop-alert-block"

    _start-cancel-btn-dom = $ "\#start-alert-block .cancel-btn"
    _start-comfirm-btn-dom = $ "\#start-alert-block .comfirm-btn"
    _stop-cancel-btn-dom = $ "\#stop-alert-block .cancel-btn"
    _stop-comfirm-btn-dom = $ "\#stop-alert-block .comfirm-btn"

    _content-business-block-dom = $ "\#order-reduce-main .content-business-block"
    _content-ladder-block-dom = $ "\#order-reduce-main .content-ladder-block"
    _ladder-content-dom = $ "\#order-reduce-main .ladder-content"

    _order-promotion = null

    _ladder-index-chinese = ['一','二','三','四','五','六','七']

    _edit-btn-click-event = !->
        edit.get-promotion-and-init _order-promotion
        page.toggle-page "edit"

    _reduce-start-btn-click-event = !->
        _start-reduce-event!

    _start-cancel-btn-click-event = !->
        _start-alert-block-dom.hide!

    _start-comfirm-btn-click-event = !->
        location.href = "/Manage/Market/Activity"

    _reduce-stop-btn-click-event = !->
        if _start-alert-block-dom.is ":hidden"
            _stop-alert-block-dom.show!

    _stop-cancel-btn-click-event = !->
        _stop-alert-block-dom.hide!

    _stop-comfirm-btn-click-event = !->
        _stop-reduce-event!
        _stop-alert-block-dom.hide!

    _start-reduce-event = !->
        $.ajax {type: "POST", url: "/Dinner/Manage/Discount/Reduce/Turn/On",\
            dataType: "JSON", contentType: "application/json", success: _start-reduce-success, error: _start-refuce-fail}

    _stop-reduce-event = !->
        $.ajax {type: "POST", url: "/Dinner/Manage/Discount/Reduce/Turn/Off",\
            dataType: "JSON", contentType: "application/json", success: _stop-reduce-success, error: _stop-reduce-fail}

    _start-reduce-success = !->
        _start-alert-block-dom.show!
        _reduce-on!

    _start-refuce-fail = !->
        alert "请求开启满减失败"
        location.reload!

    _stop-reduce-success = !->
        _reduce-stoping!

    _stop-reduce-fail = !->
        alert "请求停止满减失败"
        location.reload!

    _body-click-event = (event)!->
        if (not ($ event.target).is ".reduce-start-btn") and _start-alert-block-dom.is ':visible'
            _start-alert-block-dom.hide!
        if (not ($ event.target).is ".reduce-stop-btn") and _stop-alert-block-dom.is ':visible'
            _stop-alert-block-dom.hide!

    _reduce-stoping = !->
        _reduce-start-btn-dom.add-class "reduce-start-btn-disable"
        _reduce-start-btn-dom.text "启用满减"
        _reduce-start-btn-dom.click !-> _start-reduce-event!
        _reduce-stop-btn-dom.add-class "reduce-stop-btn-disable"
        _reduce-stop-btn-dom.text "满减停用中"
        _reduce-stop-btn-dom.unbind "click"
        _content-business-block-dom.add-class "content-disabled"
        _content-ladder-block-dom.add-class "content-disabled"
        $ "\#order-reduce-main .edit-infomation-content" .add-class "content-disabled"

    _reduce-on = !->
        _reduce-start-btn-dom.remove-class "reduce-start-btn-disable"
        _reduce-start-btn-dom.text "满减启用中"
        _reduce-start-btn-dom.unbind "click"
        _reduce-stop-btn-dom.remove-class "reduce-stop-btn-disable"
        _reduce-stop-btn-dom.text "停止满减"
        _reduce-stop-btn-dom.click !-> _reduce-stop-btn-click-event!
        _content-business-block-dom.remove-class "content-disabled"
        _content-ladder-block-dom.remove-class "content-disabled"
        $ "\#order-reduce-main .edit-infomation-content" .remove-class "content-disabled"


    _init-dom = !->
        if _order-promotion.reduce_ladder.length === 0
            _ladder-content-dom.append $ "<div class='ladder-content-item'>
                <span class='ladder-level'>尚未配置阶梯</span>
                </div>"
        for ladder-item,i in _order-promotion.reduce_ladder
            _ladder-content-dom.append $ "<div class='ladder-content-item'>
                <span class='ladder-level'>阶梯"+_ladder-index-chinese[i]+"</span>
                <span class='ladder-description'>订单消费满 "+ladder-item[0]+" 元&nbsp;&nbsp;立减 "+ladder-item[1]+" 元</span>
                </div>"
        _ladder-content-dom.append $ "<p class='edit-infomation-content'>最多可再添加 "+(7-_order-promotion.reduce_ladder.length)+ " 个阶梯</p>"
        if _order-promotion.reduce_switch === false
            _reduce-stoping!
        else
            _reduce-on!

    _init-all-event = !->
        _edit-btn-dom.click !-> _edit-btn-click-event!
        _start-comfirm-btn-dom.click !-> _start-comfirm-btn-click-event!
        _start-cancel-btn-dom.click !-> _start-cancel-btn-click-event!
        _stop-comfirm-btn-dom.click !-> _stop-comfirm-btn-click-event!
        _stop-cancel-btn-dom.click !-> _stop-cancel-btn-click-event!
        
    _init-depend-module = !->
        page 	:= require "./pageManage.js"
        edit    := require "./editManage.js"

    initial: (_get-promotion-JSON)!->
        _order-promotion := JSON.parse _get-promotion-JSON!
        _init-depend-module!
        _init-dom!
        _init-all-event!

module.exports = main-manage