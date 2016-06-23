main = null
page = null
edit-manage = let
    
    _cancel-btn-dom = $ "\#staff-role-edit .cancel-btn"
    _save-btn-dom = $ "\#staff-role-edit .save-btn"

    _name-input-dom = $ "\#staff-role-edit input[name='name']"
    _checkbox-dom = $ "\#staff-role-edit input[type='checkbox']"

    _error-message-block-dom = $ "\#staff-role-edit .error-message-block"

    _member-dom = $ "\#staff-role-edit input[value='64']" # 会员
    _member-add-dom = $ "\#staff-role-edit input[value='16777216']" # 会员充值
    _member-edit-dom = $ "\#staff-role-edit input[value='33554432']" # 修改积分

    _order-dom = $ "\#staff-role-edit input[value='2048']" # 流水订单
    _order-refund-dom = $ "\#staff-role-edit input[value='67108864']" # 退款
    _order-print-dom = $ "\#staff-role-edit input[value='134217728']" # 重打

    _data-dom = $ "\#staff-role-edit input[value='4096']" # 数据统计
    _data-print-dom = $ "\#staff-role-edit input[value='268435456']" # 打印日结

    _staff-manage-dom = $ "\#staff-role-edit input[value='131072']" # 店员管理

    _all-tbd-index = [3, 8, 9, 10, 14, 15, 20, 21, 29, 30]
    _zero-permission = 1613809416

    _edited-role = null

    _checkbox-click-event = (event)!->
        value = parse-int ($ event.target).val!
        par = ($ event.target).parent!
        if ($ event.target).is ":checked"
            _set-checkbox-checked par
            if value === 0
                sub-li-dom = par.find "ul li"
                for li in sub-li-dom
                    if not ($ li).has-class "disabled-checkbox-item"
                        _set-checkbox-checked $ li
            else
                if (par.siblings 'li.checkbox-item').length-(par.siblings "li.disabled-checkbox-item").length \
                    === (par.siblings 'li.checked-icon').length
                    _set-checkbox-checked $ par.parent!.parent!
        else
            _set-checkbox-unchecked par
            if value === 0
                sub-li-dom = par.find "ul li"
                for li in sub-li-dom
                    _set-checkbox-unchecked $ li
            else
                _set-checkbox-unchecked $ par.parent!.parent!
    
    _reset-dom = !->
        _error-message-block-dom.empty!.hide!
        _name-input-dom.val ''
        for checkbox in _checkbox-dom
            _set-checkbox-unchecked ($ checkbox).parent!
            ($ checkbox).parent!.remove-class "disabled-checkbox-item"
        _staff-manage-dom.parent!.add-class "disabled-checkbox-item"

    _get-permission-value = ->
        permission-value = 0
        for checkbox in _checkbox-dom
            if ($ checkbox).is ":checked"
                permission-value += parse-int ($ checkbox).val!
        permission-value := (_zero-permission .|. permission-value )
        permission-value
    
    _set-checkbox-checked = (checkbox-par)!->
        ($ checkbox-par.find "> input[type='checkbox']").attr 'checked',true
        if ($ checkbox-par.find "> input[type='checkbox']").val! === '64'
            _set-bound-click-able _member-add-dom
            _set-bound-click-able _member-edit-dom
        if ($ checkbox-par.find ">input[type='checkbox']").val! === '2048'
            _set-bound-click-able _order-refund-dom
            _set-bound-click-able _order-print-dom
        if ($ checkbox-par.find ">input[type='checkbox']").val! === '4096'
            _set-bound-click-able _data-print-dom
        checkbox-par.remove-class "unchecked-icon"
        checkbox-par.add-class "checked-icon"
    
    _set-checkbox-unchecked = (checkbox-par)!->
        ($ checkbox-par.find "> input[type='checkbox']").attr 'checked',false
        if ($ checkbox-par.find "> input[type='checkbox']").val! === '64'
            _set-bound-click-disable _member-add-dom
            _set-bound-click-disable _member-edit-dom
        if ($ checkbox-par.find ">input[type='checkbox']").val! === '2048'
            _set-bound-click-disable _order-refund-dom
            _set-bound-click-disable _order-print-dom
        if ($ checkbox-par.find ">input[type='checkbox']").val! === '4096'
            _set-bound-click-disable _data-print-dom
        checkbox-par.remove-class "checked-icon"
        checkbox-par.add-class "unchecked-icon"

    _cancel-btn-click-event = !->
        _reset-dom!
        page.toggle-page "main"
        
    _save-btn-click-event = !->
        name = _name-input-dom.val!
        auth = _get-permission-value!
        if _check-input-field!
            $.ajax {type: "POST", url: "/Waiter/Role/Update/"+_edited-role.id, data: {
                "name": name,
                "auth": auth
            }, dataType: "JSON", success: _update-post-success}
            _set-save-btn-disable!

    _update-post-success = (data)!->
        _set-save-btn-able!
        if data.message === "success"
            location.reload!
        else
            _display-error-message ["修改失败"]
    
    _check-input-field = ->
        error-message = []
        name = _name-input-dom.val!
        auth = _get-permission-value!
        if name === ''
            error-message.push "请输入角色名"
        if auth === _zero-permission
            error-message.push "请选择角色权限"
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

    _set-save-btn-disable = !->
        _save-btn-dom.prop "disabled",true
        _save-btn-dom.add-class "save-btn-disable"

    _set-save-btn-able = !->
        _save-btn-dom.prop "disabled",false
        _save-btn-dom.remove-class "save-btn-disable"


    _init-form-field = !->
        _name-input-dom.val _edited-role.name
        permission-string = _edited-role.permission.to-string 2
        permission-array = []
        for i from 0 to permission-string.length-1 by 1
            index = permission-string.length-1-i
            if index in _all-tbd-index
                continue
            if permission-string[i] === '1'
                permission-array.push Math.pow 2,index
        for i from permission-array.length-1 to 0 by -1
            par = ($ "\#staff-role-edit input[value='"+permission-array[i]+"']").parent!
            _set-checkbox-checked par
            if (par.siblings 'li.checkbox-item').length === (par.siblings 'li.checked-icon').length
                _set-checkbox-checked $ par.parent!.parent!
        _fix-init-form-field!

    _fix-init-form-field = !->
        if not _member-dom.is ":checked"
            _set-bound-click-disable _member-edit-dom
            _set-bound-click-disable _member-add-dom
        if not _order-dom.is ":checked"
            _set-bound-click-disable _order-refund-dom
            _set-bound-click-disable _order-print-dom
        if not _data-dom.is ":checked"
            _set-bound-click-disable _data-print-dom
        _set-bound-click-disable _staff-manage-dom
    
    _member-dom-click-event = !->
        if _member-dom.is ":checked"
            _set-bound-click-able _member-edit-dom
            _set-bound-click-able _member-add-dom
        else
            _set-bound-click-disable _member-edit-dom
            _set-bound-click-disable _member-add-dom

    _order-dom-click-event = !->
        if _order-dom.is ":checked"
            _set-bound-click-able _order-refund-dom
            _set-bound-click-able _order-print-dom
        else
            _set-bound-click-disable _order-refund-dom
            _set-bound-click-disable _order-print-dom

    _data-dom-click-event = !->
        if _data-dom.is ":checked"
            _set-bound-click-able _data-print-dom
        else
            _set-bound-click-disable _data-print-dom

    _set-bound-click-able = (dom)!->
        dom.unbind "click"
        dom.parent!.remove-class "disabled-checkbox-item"
        dom.click !-> _checkbox-click-event event
        _set-checkbox-unchecked dom.parent!
        _set-checkbox-unchecked dom.parent!.parent!.parent!

    _set-bound-click-disable = (dom)!->
        dom.parent!.add-class "disabled-checkbox-item"
        dom.unbind "click"
        _set-checkbox-unchecked dom.parent!

    _init-depend-module = !->
        page := require "./pageManage.js"
    
    _init-event = !->
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _checkbox-dom.click !-> _checkbox-click-event event
        _member-dom.click !-> _member-dom-click-event!
        _order-dom.click !-> _order-dom-click-event!
        _data-dom.click !-> _data-dom-click-event!

    get-role-and-init: (role)!->
        _edited-role := role
        _init-form-field!

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = edit-manage