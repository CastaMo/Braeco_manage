main = null
page = null
edit-manage = let

    _edit-business = null

    _cancel-btn-dom = $ "\#basic-edit .cancel-btn"
    _save-btn-dom = $ "\#basic-edit .save-btn"

    _checkbox-dom = $ "\#basic-edit input[type='checkbox']"

    _pay-method-block-dom = $ "\#basic-edit pay-method-block"

    _cancel-btn-click-event = !->
        _reset-checkebox!
        page.toggle-page 'main'

    _save-btn-click-event = !->
        channels = {}
        for checkbox in _checkbox-dom
            value = ($ checkbox).val!
            if ($ checkbox).is ":checked"
                channels[value] = 1
            else
                channels[value] = 0
        data = JSON.stringify channels
        $.ajax {type: "POST", url: "/Dinner/Manage/Firm/Update/"+_edit-business.type, data: data,\
            dataType: "JSON", contentType: "application/json", success: _save-post-success, error: _save-post-fail}
        _set-save-btn-disable!

    _save-post-success = (data)!->
        console.log data
        _set-save-btn-able!
        alert "修改成功", true
        set-timeout (!-> location.reload!), 1000

    _save-post-fail = (error)!->
        console.log error
        _set-save-btn-able!
        alert "请求修改失败"
        set-timeout (!-> location.reload!), 1000

    _set-save-btn-disable = !->
        _save-btn-dom.prop "disabled",true
        _save-btn-dom.add-class "save-btn-disable"

    _set-save-btn-able = !->
        _save-btn-dom.prop "disabled",false
        _save-btn-dom.remove-class "save-btn-disable"

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

    _init-pay-method-block-dom = !->
        for method, value of _edit-business.channels
            if value == 1
                _set-checkbox-checked ($ "input[value='"+method+"']").parent!

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _checkbox-dom.click (event)!-> _checkbox-click-event event

    get-business-and-init: (business) !->
        _edit-business := business
        console.log _edit-business
        _init-pay-method-block-dom!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = edit-manage