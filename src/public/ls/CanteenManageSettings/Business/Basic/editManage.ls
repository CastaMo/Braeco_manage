main = null
page = null
edit-manage = let

    _edit-business = null

    _block-header-dom = $ '\#basic-edit .block-header'

    _cancel-btn-dom = $ "\#basic-edit .cancel-btn"
    _save-btn-dom = $ "\#basic-edit .save-btn"

    _checkbox-dom = $ "\#basic-edit input[type='checkbox']"

    _pay-method-block-dom = $ "\#basic-edit pay-method-block"

    _type-map = {
        "eatin": "堂食",
        "takeaway": "外卖"
        "takeout": "外带",
        "reserve": "预点"
    }

    _cancel-btn-click-event = !->
        _reset-checkebox!
        $ '\#auth-link' .show!
        page.toggle-page 'main'

    _save-btn-click-event = !->
        channels = {}
        channels.channels = {}
        is-one-chosen = false
        for checkbox in _checkbox-dom
            value = ($ checkbox).val!
            if not ($ checkbox).is ':visible'
                continue
            if ($ checkbox).is ":checked"
                channels.channels[value] = 1
                is-one-chosen = true
            else
                channels.channels[value] = 0
        if not is-one-chosen
            alert "请至少选择一种支付渠道"
            return
        data = JSON.stringify channels
        $.ajax {type: "POST", url: "/Dinner/Manage/Firm/Update/"+_edit-business.type, data: data,\
            dataType: "JSON", contentType: "application/json", success: _save-post-success, error: _save-post-fail}
        _set-save-btn-disable!

    _save-post-success = (data)!->
        _set-save-btn-able!
        alert "修改成功", true
        set-timeout (!-> location.reload!), 1000

    _save-post-fail = (error)!->
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
        for checkbox in _checkbox-dom
            $ checkbox .parent!.hide!
        for method, value of _edit-business.channels
            ($ "input[value='"+method+"']").parent!.show!
            if value == 1
                _set-checkbox-checked ($ "input[value='"+method+"']").parent!

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _checkbox-dom.click (event)!-> _checkbox-click-event event

    get-business-and-init: (business, url) !->
        _edit-business := business
        _block-header-dom.text "修改"+_type-map[_edit-business.type]+"业务"
        if _edit-business.type == 'takeaway'
            $ "\#auth-link" .prop 'href', url
        else
            $ "\#auth-link" .hide!
        _init-pay-method-block-dom!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = edit-manage