page = null
new-page = null
edit-page = null
main-manage = let
    
    _all-staffs = null
    _all-roles = null
    
    _new-btn-dom = $ "\#staff-account-main .new-btn"
    _table-body-dom = $ ".sa-container-table > tbody"
    
    _new-btn-click-event = !->
        new-page._init-new-page _all-roles
        page.toggle-page 'new'
        
    _edit-btn-click-event = (staff)->
        edit-page.get-staff-and-init staff,_all-roles
        page.toggle-page 'edit'

    _delete-btn-click-event = (staff)->
        if confirm "是否确定删除"
            $.ajax {type: "POST", url: "/Waiter/Remove/"+staff.id,\
                dataType: 'JSON', contentType: "application/json", success: _delete-post-success}
            staff.delete-method-dom.unbind "click"

    _delete-post-success = (data)!->
        if data.message === 'User not found'
            alert "该店员不存在"
        if data.message === 'Is not waiter of current dinner'
            alert "该店员不是当前餐厅的员工"
        location.reload!
    
    class Staff
        
        (id, name, gender, phone, role) ->
            @id = id
            @name = name
            @gender = gender
            @phone = phone
            @role = role
            @gene-dom!
            @set-dom-value!
            @init-event!
        
        set-dom-value: !->
            @name-dom.text @name
            @gender-dom.text @gender
            @phone-dom.text @phone
            @role-dom.text @role.name
               
        gene-dom : !->
            @tr-dom = $ "<tr></tr>"
            @name-dom = $ "<td class='td-name'></td>"
            @tr-dom.append @name-dom
            @gender-dom = $ "<td class='td-gender'></td>"
            @tr-dom.append @gender-dom
            @phone-dom = $ "<td class='td-phone'></td>"
            @tr-dom.append @phone-dom 
            @role-dom = $ "<td class='td-role'></td>"
            @tr-dom.append @role-dom
            @method-dom = $ "<td class='td-method'></td>"
            @edit-method-dom = $ "<div class='method-container'>
            <icon class='edit-icon'></icon>
            <p>修改</p>
            </div>"
            @delete-method-dom = $ "<div class='method-container'>
            <icon class='delete-icon'></icon>
            <p>删除</p>
            </div>"
            @method-dom.append @edit-method-dom
            @method-dom.append @delete-method-dom
            @tr-dom.append @method-dom
            _table-body-dom.append @tr-dom
        
        init-event : !->
            @edit-method-dom.click !~> _edit-btn-click-event @
            @delete-method-dom.click !~> _delete-btn-click-event @
    
    _init-all-staff = !->
        for staff in _all-staffs
            for role in _all-roles
                if role.id === staff.role
                    staff_ = new Staff staff.id,staff.name,staff.sex,staff.phone,role
  
    _init-depend-module = !->
        page := require "./pageManage.js"
        edit-page := require "./editManage.js"
        new-page := require "./newManage.js"

    _init-event = !->
        _new-btn-dom.click !-> _new-btn-click-event!

    initial: (_get-staff-JSON, _get-role-JSON)!->
        _all-staffs := JSON.parse _get-staff-JSON!
        _all-roles := JSON.parse _get-role-JSON!
        _init-all-staff!
        _init-depend-module!
        _init-event!

module.exports = main-manage