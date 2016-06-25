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
    _comfirm-password-input-dom = $ "\#staff-account-new input[name='comfirm-password']"
    _role-select-dom = $ "\#staff-account-new select[name='role']"

    _error-message-block-dom = $ "\#staff-account-new .error-message-block"

    _all-roles = null
    
    _manage-permission-btn-click-event = !->
        current-url = location.href
        sub-current-url = current-url.substr 0,current-url.lastIndexOf '/'
        target-url = sub-current-url+'/Role'
        win = window.open(target-url, '_blank')
        win.focus!
    
    _cancel-btn-click-event = !->
        _reset-dom!
        page.toggle-page "main"
    
    _save-btn-click-event = !->
        name = _name-input-dom.val!
        gender = _gender-select-dom.val!
        phone = _phone-input-dom.val!
        password = _password-input-dom.val!
        role = _role-select-dom.val!
        if _check-input-field!
            if gender === 'male'
                gender := "男"
            else
                gender := "女"
            $.ajax {type: "POST", url: "/Waiter/Add/"+role, data: {
                "phone": phone,
                "name": name,
                "password": password,
                "sex": gender
            }, dataType: 'JSON', success: _save-post-success}
            _set-save-btn-disable!
    
    _check-input-field = ->
        error-message = []
        name = _name-input-dom.val!
        gender = _gender-select-dom.val!
        phone = _phone-input-dom.val!
        password = _password-input-dom.val!
        comfirm-password = _comfirm-password-input-dom.val!
        role = _role-select-dom.val!
        if name === ''
            error-message.push "请输入姓名"
        if phone === ''
            error-message.push "请输入电话号码"
        if phone !== ''
            re = /(^(13\d|15[^4,\D]|17[13678]|18\d)\d{8}|170[^346,\D]\d{7})$/
            if not re.test(phone)
                error-message.push "电话号码格式不正确"
        if password === ''
            error-message.push "请输入密码"
        if comfirm-password === ''
            error-message.push "请确认密码"
        if password !== comfirm-password
            error-message.push "两次输入的密码不一致"
        if role === 'default'
            error-message.push "请选择角色"
        if error-message.length === 0
            true
        else
            _display-error-message error-message
            false

    _display-error-message = (error-message)!->
        _error-message-block-dom.show!
        _error-message-block-dom.empty!
        for err in error-message
            _error-message-block-dom.append "<p>"+err+"</p>"

    _save-post-success = (data)!->
        _set-save-btn-able!
        console.log data
        if data.message === "success"
            location.reload!
        else
            _display-error-message ["添加失败"]

    _set-save-btn-disable = !->
        _save-btn-dom.prop "disabled",true
        _save-btn-dom.add-class "save-btn-disable"

    _set-save-btn-able = !->
        _save-btn-dom.prop "disabled",false
        _save-btn-dom.remove-class "save-btn-disable"

    _reset-dom = !->
        _name-input-dom.val ""
        _gender-select-dom.val ""
        _phone-input-dom.val ""
        _password-input-dom.val ""
        _comfirm-password-input-dom.val ""
        _role-select-dom.empty!.append $ "<option value='default'>请选择角色</option>"
        _error-message-block-dom.empty!.hide!

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