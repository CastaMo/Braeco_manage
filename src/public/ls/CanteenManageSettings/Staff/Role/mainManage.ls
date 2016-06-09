page =  null
main-manage = let
    
    _new-btn-dom = $ "\#staff-role-main .new-btn"
    _table-body-dom = $ ".sr-container-table > tbody"
    
    _new-btn-click-event = !->
        page.toggle-page 'new'
    
    class Role
        (name, type, permission) ->
            @name = name
            @type = type
            @permission = permission
            @gene-dom!
        
        gene-dom : !->
            @tr-dom = $ "<tr></tr>"
            @name-dom = $ "<td class='td-name'></td>"
            @tr-dom.append @name-dom
            @type-dom = $ "<td class='td-type'></td>"
            @tr-dom.append @type-dom
            @permission-dom = $ "<td class='td-permission'></td>"
            @tr-dom.append @permission-dom
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
    
    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _new-btn-dom.click !-> _new-btn-click-event!
    
    initial: !->
        _init-depend-module!
        _init-event!
        r = new Role "管理员","类型","菜单管理，营销管理，数据管理，基础业务，餐厅设置"


module.exports = main-manage