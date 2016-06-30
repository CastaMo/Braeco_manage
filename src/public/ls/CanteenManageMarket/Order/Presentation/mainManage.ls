page = null
edit = null
main-manage = let

    _presentation-start-btn-dom = $ "\#order-presentation-main .presentation-start-btn"
    _presentation-stop-btn-dom = $ "\#order-presentation-main .presentation-stop-btn"
    _edit-btn-dom = $ "\#order-presentation-main .edit-btn"

    _start-alert-block-dom = $ "\#start-alert-block"
    _stop-alert-block-dom = $ "\#stop-alert-block"

    _start-cancel-btn-dom = $ "\#start-alert-block .cancel-btn"
    _start-comfirm-btn-dom = $ "\#start-alert-block .comfirm-btn"
    _stop-cancel-btn-dom = $ "\#stop-alert-block .cancel-btn"
    _stop-comfirm-btn-dom = $ "\#stop-alert-block .comfirm-btn"

    _content-business-block-dom = $ "\#order-presentation-main .content-business-block"
    _content-ladder-block-dom = $ "\#order-presentation-main .content-ladder-block"
    _ladder-content-dom = $ "\#order-presentation-main .ladder-content"

    _order-promotion = null
    
    _ladder-index-chinese = ['一','二','三','四','五','六','七']

    _edit-btn-click-event = !->
        edit.get-promotion-and-init _order-promotion
        page.toggle-page "edit"

    _presentation-stop-btn-click-event = !->
        _stop-alert-block-dom.show!

    _stop-cancel-btn-click-event = !->
        _stop-alert-block-dom.hide!

    _stop-comfirm-btn-click-event = !->
        _stop-presentation-event!

    _start-comfirm-btn-click-event = !->
        location.href = "/Manage/Market/Activity"
        
    _start-presentation-event = !->
        $.ajax {type: "POST", url: "/Dinner/Manage/Discount/Give/Turn/On",\
            dataType: "JSON", contentType: "application/json", success: _start-presentation-success}

    _stop-presentation-event = !->
        $.ajax {type: "POST", url: "/Dinner/Manage/Discount/Give/Turn/Off",\
            dataType: "JSON", contentType: "application/json", success: _stop-presentation-success}


    _start-presentation-success = (data)!->
        _start-alert-block-dom.show!
        _give-on!

    _stop-presentation-success = (data)!->
        _give-stoping!

    _body-click-event = (event)!->
        if (not ($ event.target).is ".presentation-start-btn") and _start-alert-block-dom.is ':visible'
            _start-alert-block-dom.hide!
        if (not ($ event.target).is ".presentation-stop-btn") and _stop-alert-block-dom.is ':visible'
            _stop-alert-block-dom.hide!


    _give-stoping = !->
        _presentation-start-btn-dom.add-class "presentation-start-btn-disable"
        _presentation-start-btn-dom.text "启用满送"
        _presentation-start-btn-dom.click !-> _start-presentation-event!
        _presentation-stop-btn-dom.add-class "presentation-stop-btn-disable"
        _presentation-stop-btn-dom.text "满送停用中"
        _presentation-stop-btn-dom.unbind "click"
        _content-business-block-dom.add-class "content-disabled"
        _content-ladder-block-dom.add-class "content-disabled"
        $ "\#order-presentation-main .edit-infomation-content" .add-class "content-disabled"


    _give-on = !->
        _presentation-start-btn-dom.remove-class "presentation-start-btn-disable"
        _presentation-start-btn-dom.text "满送启用中"
        _presentation-start-btn-dom.unbind "click"
        _presentation-stop-btn-dom.remove-class "presentation-stop-btn-disable"
        _presentation-stop-btn-dom.text "停止满送"
        _presentation-stop-btn-dom.click !-> _presentation-stop-btn-click-event!
        _content-business-block-dom.remove-class "content-disabled"
        _content-ladder-block-dom.remove-class "content-disabled"
        $ "\#order-presentation-main .edit-infomation-content" .remove-class "content-disabled"


    _init-dom = !->
        if _order-promotion.give_ladder.length === 0
            _ladder-content-dom.append $ "<div class='ladder-content-item'>
                <span class='ladder-level'>尚未配置阶梯</span>
                </div>"
        for ladder-item,i in _order-promotion.give_ladder
            _ladder-content-dom.append $ "<div class='ladder-content-item'>
                <span class='ladder-level'>阶梯"+_ladder-index-chinese[i]+"</span>
                <span class='ladder-description'>订单消费满 "+ladder-item[0]+" 元&nbsp;&nbsp;立送 "+ladder-item[1]+" 一份</span>
                </div>"
        _ladder-content-dom.append $ "<p class='edit-infomation-content'>最多可再添加 "+(7-_order-promotion.give_ladder.length)+ " 个阶梯</p>"
        if _order-promotion.give_switch === false
            _give-stoping!
        else
            _give-on!
        

    _init-all-event = !->
        _edit-btn-dom.click !-> _edit-btn-click-event!
        _stop-comfirm-btn-dom.click !-> _stop-comfirm-btn-click-event!
        _start-comfirm-btn-dom.click !-> _start-comfirm-btn-click-event!
        $ "body" .click !-> _body-click-event event
        
    _init-depend-module = !->
        page    := require "./pageManage.js"
        edit    := require "./editManage.js"

    initial: (_get-promotion-JSON)!->
        _order-promotion := JSON.parse _get-promotion-JSON!
        _init-depend-module!
        _init-dom!
        _init-all-event!

module.exports = main-manage