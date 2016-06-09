page = null
edit-page = null
main-manage = let
    
    _new-btn-dom = $ "\#staff-account-main .new-btn"
    _table-body-dom = $ ".sa-container-table > tbody"
    
    _new-btn-click-event = !->
        page.toggle-page 'new'
        
    _edit-btn-click-event = (staff)->
        edit-page.get-staff-and-init staff
        page.toggle-page 'edit'
    
    class Staff
        
        (name, gender, phone, role) ->
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
            @role-dom.text @role
               
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
        
    _init-depend-module = !->
        page := require "./pageManage.js"
        edit-page := require "./editManage.js"

    _init-event = !->
        _new-btn-dom.click !-> _new-btn-click-event!

    initial: !->
        _init-depend-module!
        _init-event!
        s = new Staff "韦小宝","男","18819481270","管理员"
        s = new Staff "乔峰","男","12345678910","管理员"

module.exports = main-manage