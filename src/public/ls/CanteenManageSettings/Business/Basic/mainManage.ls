page = null
main-manage = let
    
    _outer-content-link-dom = $ "\#outer-content-link"
    _outer-copy-btn-dom = $ "\#outer-copy-btn"
    _pre-content-link-dom = $ "\#pre-content-link"
    _pre-copy-btn-dom = $ "\#pre-copy-btn"

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

    _outer-copy-btn-click-event = !->
        _copy-to-clipboard _outer-content-link-dom.text!

    _pre-copy-btn-click-event = !->
        _copy-to-clipboard _pre-content-link-dom.text!

    _init-depend-module = !->
        page := require "./pageManage.js"

    _init-all-event = !->

    initial: !->
        _init-depend-module!
        _init-all-event!
        _outer-copy-btn-dom.click !-> _outer-copy-btn-click-event!
        _pre-copy-btn-dom.click !-> _pre-copy-btn-click-event!


module.exports = main-manage
