page = null
main-manage = let
    
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
    # common finish

    # canteen
    _is-canteen-started = false

    _canteen-start-btn-dom = $ "\#canteen-start-btn"
    _canteen-stop-btn-dom = $ "\#canteen-stop-btn"
    _canteen-edit-btn-dom = $ "\#canteen-edit-btn"
    _canteen-alert-block-dom = $ "\#canteen-alert-block"
    _canteen-comfirm-btn-dom = $ "\#canteen-comfirm-btn"
    _canteen-cancel-btn-dom = $ "\#canteen-cancel-btn"

    _init-cantent-status = !->
        if _is-canteen-started
            _set-starting-status _canteen-start-btn-dom,_canteen-stop-btn-dom, _canteen-stop-btn-click-event
        else
            _set-stopping-status _canteen-start-btn-dom,_canteen-stop-btn-dom, _canteen-start-btn-click-event

    _canteen-start-btn-click-event = !->
        _is-canteen-started := true
        _init-cantent-status!

    _canteen-stop-btn-click-event = !->
        _canteen-alert-block-dom.show!

    _canteen-comfirm-btn-click-event = !->
        _is-canteen-started := false
        _init-cantent-status!
        _canteen-alert-block-dom.hide!

    _canteen-cancel-btn-click-event = !->
        _canteen-alert-block-dom.hide!

    _canteen-edit-btn-click-event = !->
        page.toggle-page 'edit'

    _init-canteen-event = !->
        _init-cantent-status!
        _canteen-comfirm-btn-dom.click !-> _canteen-comfirm-btn-click-event!
        _canteen-cancel-btn-dom.click !-> _canteen-cancel-btn-click-event!
        _canteen-edit-btn-dom.click !-> _canteen-edit-btn-click-event!
    # canten finish

    # sellout
    _sellout-content-link-dom = $ "\#sellout-content-link"
    _sellout-copy-btn-dom = $ "\#sellout-copy-btn"
    _sellout-edit-btn-dom = $ "\#sellout-edit-btn"

    _sellout-edit-btn-click-event = !->
        page.toggle-page 'edit'

    _sellout-copy-btn-click-event = !->
        _copy-to-clipboard _sellout-content-link-dom.text!

    _init-sellout-event = !->
        _sellout-edit-btn-dom.click !-> _sellout-edit-btn-click-event!
        _sellout-copy-btn-dom.click !-> _sellout-copy-btn-click-event!
    # sellout finish

    _init-depend-module = !->
        page := require "./pageManage.js"

    _init-all-event = !->
        _init-canteen-event!
        _init-sellout-event!

    initial: !->
        _init-depend-module!
        _init-all-event!

module.exports = main-manage
