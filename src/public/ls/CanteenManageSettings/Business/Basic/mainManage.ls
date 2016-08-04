page = null
edit = null
main-manage = let
    
    _all-business = null
    _eatin-data = null
    _takeout-data = null
    _takeaway-data = null
    _reserve-data = null

    _method-map = {
        "p2p_wx_pub": "微信支付",
        "cash": "现金支付"
    }

    # common
    _copy-to-clipboard = (text)!->
        hidden-textarea = $ "<textarea></textarea>"
        hidden-textarea.val text
        $ 'body' .append hidden-textarea
        hidden-textarea.select!
        try
            successful = document.execCommand 'copy'
            msg = successful ? 'successful' : 'unsuccessful'
            console.log 'Copying text command was ' + msg
            alert "复制成功",true
        catch error
            console.log 'Unable to copy'
        hidden-textarea.remove!

    _download-qrcode = (qrcode-src)!->
        a = $ "<a>" .attr "href", qrcode-src .attr "download", "image.png" .appendTo "body"
        a[0].click!
        a.remove!

    _set-stopping-status = (start-btn, stop-btn, click-event)!->
        start-btn.remove-class "business-start-btn-able"
        start-btn.add-class "business-start-btn-disable"
        start-btn.text "启用业务"
        start-btn.click click-event
        stop-btn.remove-class "business-stop-btn-able"
        stop-btn.add-class "business-stop-btn-disable"
        stop-btn.text "业务停用中"
        stop-btn.unbind "click"

    _set-starting-status = (start-btn, stop-btn, click-event)!->
        start-btn.remove-class "business-start-btn-disable"
        start-btn.add-class "business-start-btn-able"
        start-btn.text "业务启用中"
        start-btn.unbind "click"
        stop-btn.remove-class "business-stop-btn-disable"
        stop-btn.add-class "business-stop-btn-able"
        stop-btn.text "停止业务"
        stop-btn.click click-event

    _set-business-method-content-dom = (business-type, business-method)!->
        business-method-content-dom = $ "#"+business-type+"-method-content"
        method-strings = []
        for method, value of business-method
            if value == 1
                method-strings.push _method-map[method]
        business-method-content-dom.text (method-strings.join '、')

    _business-turn-on = (business-type)!->
        $.ajax {type: "POST", url: "/Dinner/Manage/Firm/Turn/"+business-type+"/On",\
            dataType: "JSON", contentType: "application/json", success: _business-turn-success, error: _business-trun-fail}

    _business-turn-off = (business-type, alert-block-dom)!->
        $.ajax {type: "POST", url: "/Dinner/Manage/Firm/Turn/"+business-type+"/Off",\
            dataType: "JSON", contentType: "application/json", success: _business-turn-success, error: _business-trun-fail}
        alert-block-dom.hide!
    
    _business-turn-success = (data)!->
        console.log data
        location.reload!

    _business-trun-fail = (error)!->
        console.log error
        alert "请求失败"
        set-timeout (!-> location.reload), 1000
    # common finish

    # eatin
    _eatin-start-btn-dom = $ "\#eatin-start-btn"
    _eatin-stop-btn-dom = $ "\#eatin-stop-btn"
    _eatin-alert-block-dom = $ "\#eatin-alert-block"
    _eatin-comfirm-btn-dom = $ "\#eatin-comfirm-btn"
    _eatin-cancel-btn-dom = $ "\#eatin-cancel-btn"
    _eatin-edit-btn-dom = $ "\#eatin-edit-btn"

    _init-eatin = !->
        _init-eatin-status!
        _set-business-method-content-dom _eatin-data.type, _eatin-data.channels

    _init-eatin-status = !->
        if _eatin-data.able
            _set-starting-status _eatin-start-btn-dom,_eatin-stop-btn-dom, _eatin-stop-btn-click-event
        else
            _set-stopping-status _eatin-start-btn-dom,_eatin-stop-btn-dom, _eatin-start-btn-click-event

    _eatin-start-btn-click-event = !->
        _business-turn-on _eatin-data.type

    _eatin-stop-btn-click-event = !->
        _eatin-alert-block-dom.show!

    _eatin-comfirm-btn-click-event = !->
        _business-turn-off _eatin-data.type, _eatin-alert-block-dom

    _eatin-cancel-btn-click-event = !->
        _eatin-alert-block-dom.hide!

    _eatin-edit-btn-click-event = !->
        edit.get-business-and-init _eatin-data
        page.toggle-page 'edit'

    _init-eatin-event = !->
        _init-eatin!
        _eatin-comfirm-btn-dom.click !-> _eatin-comfirm-btn-click-event!
        _eatin-cancel-btn-dom.click !-> _eatin-cancel-btn-click-event!
        _eatin-edit-btn-dom.click !-> _eatin-edit-btn-click-event!
    # eatin finish

    # takeaway
    _takeaway-start-btn-dom = $ "\#takeaway-start-btn"
    _takeaway-stop-btn-dom = $ "\#takeaway-stop-btn"
    _takeaway-alert-block-dom = $ "\#takeaway-alert-block"
    _takeaway-comfirm-btn-dom = $ "\#takeaway-comfirm-btn"
    _takeaway-cancel-btn-dom = $ "\#takeaway-cancel-btn"
    _takeaway-edit-btn-dom = $ "\#takeaway-edit-btn"

    _takeaway-content-qrcode-dom = $ "\#takeaway-content-qrcode"
    _takeaway-download-dom = $ "\#takeaway-download-btn"
    _takeaway-content-link-dom = $ "\#takeaway-content-link"
    _takeaway-copy-btn-dom = $ "\#takeaway-copy-btn"

    _init-takeaway = !->
        _init-takeaway-status!
        _set-business-method-content-dom _takeaway-data.type, _takeaway-data.channels
        _takeaway-content-qrcode-dom.attr "src",_takeaway-data.qr
        _takeaway-content-link-dom.text _takeaway-data.url

    _init-takeaway-status = !->
        if _takeaway-data.able
            _set-starting-status _takeaway-start-btn-dom,_takeaway-stop-btn-dom, _takeaway-stop-btn-click-event
        else
            _set-stopping-status _takeaway-start-btn-dom,_takeaway-stop-btn-dom, _takeaway-start-btn-click-event

    _takeaway-start-btn-click-event = !->
        _business-turn-on _takeaway-data.type

    _takeaway-stop-btn-click-event = !->
        _takeaway-alert-block-dom.show!

    _takeaway-comfirm-btn-click-event = !->
        _business-turn-off _takeaway-data.type, _takeaway-alert-block-dom

    _takeaway-cancel-btn-click-event = !->
        _takeaway-alert-block-dom.hide!

    _takeaway-edit-btn-click-event = !->
        edit.get-business-and-init _takeaway-data
        page.toggle-page 'edit'

    _takeaway-copy-btn-click-event = !->
        _copy-to-clipboard _takeaway-content-link-dom.text!

    _takeaway-download-btn-click-event = !->
        _download-qrcode _takeaway-data.qr

    _init-takeaway-event = !->
        _init-takeaway!
        _takeaway-comfirm-btn-dom.click !-> _takeaway-comfirm-btn-click-event!
        _takeaway-cancel-btn-dom.click !-> _takeaway-cancel-btn-click-event!
        _takeaway-edit-btn-dom.click !-> _takeaway-edit-btn-click-event!
        _takeaway-copy-btn-dom.click !-> _takeaway-copy-btn-click-event!
        _takeaway-download-dom.click !-> _takeaway-download-btn-click-event!
    # takeaway finish

    # takeout
    _takeout-start-btn-dom = $ "\#takeout-start-btn"
    _takeout-stop-btn-dom = $ "\#takeout-stop-btn"
    _takeout-alert-block-dom = $ "\#takeout-alert-block"
    _takeout-comfirm-btn-dom = $ "\#takeout-comfirm-btn"
    _takeout-cancel-btn-dom = $ "\#takeout-cancel-btn"
    _takeout-edit-btn-dom = $ "\#takeout-edit-btn"

    _takeout-content-qrcode-dom = $ "\#takeout-content-qrcode"
    _takeout-download-dom = $ "\#takeout-download-btn"
    _takeout-content-link-dom = $ "\#takeout-content-link"
    _takeout-copy-btn-dom = $ "\#takeout-copy-btn"

    _init-takeout = !->
        _init-takeout-status!
        _set-business-method-content-dom _takeout-data.type, _takeout-data.channels
        _takeout-content-qrcode-dom.attr "src",_takeout-data.qr
        _takeout-content-link-dom.text _takeout-data.url

    _init-takeout-status = !->
        if _takeout-data.able
            _set-starting-status _takeout-start-btn-dom,_takeout-stop-btn-dom, _takeout-stop-btn-click-event
        else
            _set-stopping-status _takeout-start-btn-dom,_takeout-stop-btn-dom, _takeout-start-btn-click-event

    _takeout-start-btn-click-event = !->
        _business-turn-on _takeout-data.type

    _takeout-stop-btn-click-event = !->
        _takeout-alert-block-dom.show!

    _takeout-comfirm-btn-click-event = !->
        _business-turn-off _takeout-data.type, _takeout-alert-block-dom

    _takeout-cancel-btn-click-event = !->
        _takeout-alert-block-dom.hide!

    _takeout-edit-btn-click-event = !->
        edit.get-business-and-init _takeout-data
        page.toggle-page 'edit'

    _takeout-copy-btn-click-event = !->
        _copy-to-clipboard _takeout-content-link-dom.text!

    _takeout-download-btn-click-event = !->
        _download-qrcode _takeout-data.qr

    _init-takeout-event = !->
        _init-takeout!
        _takeout-comfirm-btn-dom.click !-> _takeout-comfirm-btn-click-event!
        _takeout-cancel-btn-dom.click !-> _takeout-cancel-btn-click-event!
        _takeout-edit-btn-dom.click !-> _takeout-edit-btn-click-event!
        _takeout-copy-btn-dom.click !-> _takeout-copy-btn-click-event!
        _takeout-download-dom.click !-> _takeout-download-btn-click-event!
    # takeout finish

    _init-data = (_get-business-JSON)!->
        _all-business := JSON.parse _get-business-JSON!
        for data in _all-business
            if data.type == 'eatin'
                _eatin-data := data
            if data.type == 'takeout'
                _takeout-data := data
            if data.type == 'takeaway'
                _takeaway-data := data
            if data.type == 'reserve'
                _reserve-data := data

    _init-depend-module = !->
        page := require "./pageManage.js"
        edit := require "./editManage.js"

    _init-all-event = !->
        _init-eatin-event!
        _init-takeaway-event!
        _init-takeout-event!

    initial: (_get-business-JSON)!->
        _init-data _get-business-JSON
        _init-depend-module!
        _init-all-event!

module.exports = main-manage
