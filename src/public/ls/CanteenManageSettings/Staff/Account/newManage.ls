main = null
page = null
new-manage = let

    _manage-permission-btn-dom = $ "\#staff-account-new .manage-permission-btn"
    
    _cancel-btn-dom = $ "\#staff-account-new .cancel-btn"
    _save-btn-dom = $ "\#staff-account-new .save-btn"

    _name-input-dom = $ "\#staff-account-new input[name='name']"
    _gender-select-dom = $ "\#staff-account-new select[name='gender']"
    _phone-input-dom = $ "\#staff-account-new input[name='phone']"
    _password-input-dom = $ "\#staff-account-new input[name='password']"
    _reset-password-btn-dom = $ "\#staff-account-new button.reset-password-btn"
    _role-select-dom = $ "\#staff-account-new select[name='role']"

    _all-roles = null
    
    _manage-permission-btn-click-event = !->
        current-url = location.href
        sub-current-url = current-url.substr 0,current-url.lastIndexOf '/'
        target-url = sub-current-url+'/Role'
        win = window.open(target-url, '_blank')
        win.focus!
    
    _cancel-btn-click-event = !->
        page.toggle-page "main"
    
    _save-btn-click-event = !->
        page.toggle-page "main"

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _manage-permission-btn-dom.click !-> _manage-permission-btn-click-event!
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!

    _init-role-select-dom = !->
        for role in _all-roles
            _role-select-dom.append $ "<option value='"+role.id+"''>"+role.name+"</option>"

    _init-new-page : (roles)!->
        _all-roles := roles
        _init-role-select-dom!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = new-manage