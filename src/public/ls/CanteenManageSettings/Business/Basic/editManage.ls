main = null
page = null
edit-manage = let

    _all-roles = null
    _edited-staff = null

    _cancel-btn-dom = $ "\#basic-edit .cancel-btn"
    _save-btn-dom = $ "\#basic-edit .save-btn"

    _checkbox-dom = $ "\#basic-edit input[type='checkbox']"

    _cancel-btn-click-event = !->
        _reset-checkebox!
        page.toggle-page 'main'

    _save-btn-click-event = !->
        _reset-checkebox!
        page.toggle-page 'main'

    _checkbox-click-event = (event)!->
        par = ($ event.target).parent!
        if ($ event.target).is ":checked"
            _set-checkbox-checked par
        else
            _set-checkbox-unchecked par

    _set-checkbox-checked = (checkbox-par)!->
        ($ checkbox-par .find "> input[type='checkbox']").attr 'checked',true
        checkbox-par.remove-class "unchecked-icon"
        checkbox-par.add-class "checked-icon"

    _set-checkbox-unchecked = (checkbox-par)!->
        ($ checkbox-par.find "> input[type='checkbox']").attr 'checked',false
        checkbox-par.remove-class "checked-icon"
        checkbox-par.add-class "unchecked-icon"

    _reset-checkebox = !->
        _checkbox-dom.each !->
            _set-checkbox-unchecked ($ this).parent!

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _checkbox-dom.click (event)!-> _checkbox-click-event event

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
        selected = ($ _role-select-dom.find "option").filter ->
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