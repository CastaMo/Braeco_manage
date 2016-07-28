main = null
page = null
edit-manage = let

    _all-roles = null

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->

        
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