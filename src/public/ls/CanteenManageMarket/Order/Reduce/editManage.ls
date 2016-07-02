page = null
edit-manage = let

    _ladder-content-dom = $ "\#order-reduce-edit .ladder-content"

    _add-btn-dom = $ "\#order-reduce-edit .add-ladder-btn"

    _cancel-btn-dom = $ "\#order-reduce-edit .cancel-btn"
    _save-btn-dom = $ "\#order-reduce-edit .save-btn"

    _checkbox-inputs-dom = $ "\#order-reduce-edit .business-content input[type='checkbox']"

    item-manager = null
    
    _ladder-index-chinese = ['一','二','三','四','五','六','七']

    _add-btn-click-event = !->
        item-manager.add-new-item!

    _cancel-btn-click-event = !->
        _reset-dom!
        page.toggle-page "main"

    _save-btn-click-event = !->
        # _reset-dom!
        # page.toggle-page "main"
        result = item-manager.get-reduce-contents!
        if typeof result === 'string'
            alert result
        else
            console.log JSON.stringify result
            json-result = JSON.stringify result
            $.ajax {type: "POST", url: "/Dinner/Manage/Discount/Reduce/Update", data: json-result,\
                dataType: "JSON", contentType: "application/json", success: _update-reduce-success, error: _update-reduce-fail}
            _set-save-button-disable!

    _checkbox-change-event = (event)!->
        checkbox = $ event.target
        parent = checkbox.parent!
        if checkbox.is ":checked"
            parent.remove-class 'unchecked-checkbox-item'
            parent.add-class 'checked-checkbox-item'
        else
            parent.remove-class 'checked-checkbox-item'
            parent.add-class 'unchecked-checkbox-item'

    _update-reduce-success = (data)!->
        _set-save-button-able!
        if data.message === 'success'
            location.reload!
        else
            alert "请求修改规则失败"

    _update-reduce-fail = (data)!->
        _set-save-button-able!
        alert "请求修改规则失败"

    _set-save-button-disable = !->
        _save-btn-dom.prop 'disabled', true

    _set-save-button-able = !->
        _save-btn-dom.prop 'disabled', false

    _reset-dom =!->
        _ladder-content-dom.empty!

    class LadderItem
        (index, condition, reduce) !->
            @index = index
            @condition = condition
            @reduce = reduce
            @gene-dom!
            @init-event!

        gene-dom: !->
            @dom = $ "<div class='ladder-content-item'></div>"
            @index-dom = $ "<span class='ladder-level'>阶梯"+_ladder-index-chinese[@index]+"</span>"
            @dom.append @index-dom
            @dom.append $ "<span>订单消费满</span>"
            @condition-input = $ "<input type='text' name='condition' value='"+@condition+"'>"
            @dom.append @condition-input
            @dom.append $ "<span class='money-content'>元</span>
            <span>立减</span>"
            @reduce-input = $ "<input type='text' name='reduce' value='"+@reduce+"'>"
            @dom.append @reduce-input
            @dom.append $ "<span class='money-content'>元</span>"
            @delete-icon = $ "<icon class='delete-icon'></icon>"
            @dom.append @delete-icon
            _ladder-content-dom.append @dom

        get-reduce-content: ->
            [(parse-float @condition), (parse-float @reduce)]

        update-index-dom: !->
            @index-dom.text "阶梯"+_ladder-index-chinese[@index]

        update-condition-dom: !->
            @condition-input.val @condition

        update-reduce-dom: !->
            @reduce-input.val @reduce

        delete-dom: !->
            @dom.remove!

        init-event: !->
            @condition-input.change !~>
                result = parse-float @condition-input.val!
                if isNaN result
                    @condition = null
                    alert "请填写数字"
                else
                    @condition = parse-float result
                @update-condition-dom!
            @reduce-input.change !~>
                result = parse-float @reduce-input.val!
                if isNaN result
                    @reduce = null
                    alert "请填写数字"
                else
                    @reduce = parse-float result
                @update-reduce-dom!
            @delete-icon.click !~>
                item-manager.delete-item @index


    class ItemManager
        (ladder_reduce) !->
            @items = []
            if ladder_reduce.length === 0
                @items.push new LadderItem 0,'',''
            for item, i in ladder_reduce
                @items.push new LadderItem i,item[0],item[1]

        add-new-item: !->
            if @items.length < 7
                @items.push new LadderItem @items.length,'',''
                if @items.length === 7
                    _add-btn-dom.hide!
            if @items.length > 0
                _add-btn-dom.remove-class "zero-add-ladder-btn"

        delete-item: (index)!->
            if @items.length === 7
                _add-btn-dom.show!
            removed-items = @items.splice index,1
            removed-item = removed-items[0]
            removed-item.delete-dom!
            @update-items-index!
            if @items.length === 0
                _add-btn-dom.add-class "zero-add-ladder-btn"

        update-items-index: !->
            for item, i in @items
                item.index = i
                item.update-index-dom!

        get-reduce-contents: ->
            contents = []
            current-condition = 0.0
            current-reduce = 0.0
            for item in @items
                content = item.get-reduce-content!
                if isNaN content[0] or isNaN content[1]
                    return "请填写数字"
                if content[0] < current-condition or content[1] < current-reduce
                    return "每一项的两个数都必须大于前一项"
                current-condition = content[0]
                current-reduce = content[1]
                contents.push content
            contents



    _init-all-event = !->
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _add-btn-dom.click !-> _add-btn-click-event!
        _checkbox-inputs-dom.change !-> _checkbox-change-event event

    _init-depend-module = !->
        page    := require "./pageManage.js"

    get-promotion-and-init: (promotion)!->
        item-manager := new ItemManager promotion.reduce_ladder

    initial: !->
        _init-depend-module!
        _init-all-event!

module.exports = edit-manage