page = null
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

    _reduce-start-btn-click-event = !->
        _start-alert-block-dom.show!

    _reduce-stop-btn-click-event = !->
        _stop-alert-block-dom.show!

    _edit-btn-click-event = !->
        page.toggle-page "edit"

    _start-cancel-btn-click-event = !->
        _start-alert-block-dom.hide!

    _stop-cancel-btn-click-event = !->
        _stop-alert-block-dom.hide!


    _body-click-event = (event)!->
        if (not ($ event.target).is ".reduce-start-btn") and _start-alert-block-dom.is ':visible'
            _start-alert-block-dom.hide!
        if (not ($ event.target).is ".reduce-stop-btn") and _stop-alert-block-dom.is ':visible'
            _stop-alert-block-dom.hide!

    _init-all-event = !->
        _reduce-start-btn-dom.click !-> _reduce-start-btn-click-event!
        _reduce-stop-btn-dom.click !-> _reduce-stop-btn-click-event!
        _edit-btn-dom.click !-> _edit-btn-click-event!
        _start-cancel-btn-dom.click !-> _start-cancel-btn-click-event!
        _stop-cancel-btn-dom.click !-> _stop-cancel-btn-click-event!
        $ "body" .click !-> _body-click-event event
        
    _init-depend-module = !->
        page 	:= require "./pageManage.js"

    initial: !->
        _init-depend-module!
        _init-all-event!

module.exports = main-manage