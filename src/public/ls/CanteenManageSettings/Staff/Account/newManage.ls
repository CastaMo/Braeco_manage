main = null
page = null
new-manage = let

    _cancel-btn-dom = $ "\#staff-account-new .cancel-btn"
    _save-btn-dom = $ "\#staff-account-new .save-btn"
    
    _cancel-btn-click-event = !->
        page.toggle-page "main"
    
    _save-btn-click-event = !->
        page.toggle-page "main"

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = new-manage