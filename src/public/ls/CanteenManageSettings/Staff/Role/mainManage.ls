page =  null
edit-page = null
main-manage = let
    
    _all-roles = null

    _new-btn-dom = $ "\#staff-role-main .new-btn"
    _table-body-dom = $ ".sr-container-table > tbody"

    _all-permission = ['编辑餐牌','隐藏、显示、移动、排序餐品或品类','（待定）','（待定）',
    '活动管理','订单优惠','会员','卡券', '搭配推荐','（待定）','（待定）',
    '流水订单','数据统计','营销分析','（待定）','（待定）',
    '业务管理','店员管理','餐厅信息修改','餐厅日志','（待定）','（待定）',
    '接单处理','辅助点餐','会员充值','修改积分','退款','重打某单','打印日结','（待定）','（待定）']

    _new-btn-click-event = !->
        page.toggle-page 'new'
    
    _edit-btn-click-event = (role)->
        edit-page.get-role-and-init role
        page.toggle-page 'edit'
    
    class Role
        (name, type, permission) ->
            @name = name
            @type = type
            @permission = permission
            @gene-dom!
            @set-dom-value!
            @init-event!
            @gene-permission-string!

        gene-permission-string: !->
            permission-string = []
            binary-string = @permission.to-string 2
            for i from binary-string.length-1 to 0 by -1
                if binary-string[i] === '1'
                    console.log i
                    permission-string.push _all-permission[binary-string.length-1-i]
            @permission-dom.text permission-string.join '，'

        set-dom-value: !->
            @name-dom.text @name
            @type-dom.text @type
            @permission-dom.text @permission
        
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
        
        init-event : !->
            @edit-method-dom.click !~> _edit-btn-click-event @
    
    _init-all-role = !->
        for role in _all-roles
            role_ = new Role role.name,role.type,role.auth

    _init-depend-module = !->
        page := require "./pageManage.js"
        edit-page := require "./editManage.js"
        
    _init-event = !->
        _new-btn-dom.click !-> _new-btn-click-event!
    
    initial: (_get-role-JSON)!->
        _all-roles := JSON.parse _get-role-JSON!
        _init-all-role!
        _init-depend-module!
        _init-event!


module.exports = main-manage