main = null
page = null
edit-manage = let

    _full-cover-dom = $ "\#full-cover"
    
    _full-cover-close-btn-dom = $ "\#full-cover .close-btn"
    _full-cover-cancel-btn-dom = $ "\#full-cover .cancel-btn"
    _full-cover-save-btn-dom = $ "\#full-cover .save-btn"

    _edited-staff = null
    _all-roles = null
    
    _manage-permission-btn-dom = $ "\#staff-account-edit .manage-permission-btn"
    
    _cancel-btn-dom = $ "\#staff-account-edit .cancel-btn"
    _save-btn-dom = $ "\#staff-account-edit .save-btn"
    
    _name-input-dom = $ "\#staff-account-edit input[name='name']"
    _gender-select-dom = $ "\#staff-account-edit select[name='gender']"
    _phone-input-dom = $ "\#staff-account-edit input[name='phone']"
    _password-input-dom = $ "\#staff-account-edit input[name='password']"
    _reset-password-btn-dom = $ "\#staff-account-edit button.reset-password-btn"
    _role-select-dom = $ "\#staff-account-edit select[name='role']"
    
    _reset-password-btn-click-event = !->
        _full-cover-dom.fade-in 100
        
    _full-cover-close-btn-click-event = !->
        _full-cover-dom.fade-out 100
        
    _full-cover-cancel-btn-click-event = !->
        _full-cover-dom.fade-out 100
    
    _full-cover-save-btn-click-event = !->
        _full-cover-dom.fade-out 100
    
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
        _reset-password-btn-dom.click !-> _reset-password-btn-click-event!
        _full-cover-close-btn-dom.click !-> _full-cover-close-btn-click-event!
        _full-cover-cancel-btn-dom.click !-> _full-cover-cancel-btn-click-event!
        _full-cover-save-btn-dom.click !-> _full-cover-save-btn-click-event!
        
    _init-role-select-dom = !->
        for role in _all-roles
            _role-select-dom.append $ "<option value='"+role.id+"''>"+role.name+"</option>"
    
    _init-form-field = !->
        _name-input-dom.val _edited-staff.name
        selected = ($ _gender-select-dom.find "option").filter ->
            if ($ this).text! === _edited-staff.gender
                true
            else
                false
        ($ selected).prop 'selected',true
        _phone-input-dom.val _edited-staff.phone
        _password-input-dom.val "*******"
        selected = ($ _role-select-dom.find "option").filter ->
            console.log ($ this).val!
            if ($ this).val! === _edited-staff.role.id.to-string!
                true
            else
                false
        ($ selected).prop "selected",true

    get-staff-and-init: (staff, roles) !->
        _all-roles := roles
        _edited-staff := staff
        _init-role-select-dom!
        _init-form-field!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = edit-manage