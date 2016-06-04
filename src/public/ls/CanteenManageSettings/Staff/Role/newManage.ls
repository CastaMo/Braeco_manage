main = null
page = null
new-manage = let
    
    _cancel-btn-dom = $ "\#staff-role-new .cancel-btn"
    _save-btn-dom = $ "\#staff-role-new .save-btn"
    
    _name-input-dom = $ "\#staff-role-new input[name='name']"
    _checkbox-dom = $ "\#staff-role-new input[type='checkbox']"
    
    _checkbox-click-event = (event)!->
        value = parse-int ($ event.target).val!
        par = ($ event.target).parent!
        if ($ event.target).is ":checked"
            _set-checkbox-checked par
            if value === 0
                sub-li-dom = par.find "ul li"
                for li in sub-li-dom
                    _set-checkbox-checked $ li
            else
                if (par.siblings 'li.checkbox-item').length === (par.siblings 'li.checked-icon').length
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
        _name-input-dom.val ''
        for checkbox in _checkbox-dom
            _set-checkbox-unchecked ($ checkbox).parent!
    
    _get-permission-value = ->
        permission-value = 0
        for checkbox in _checkbox-dom
            if ($ checkbox).is ":checked"
                permission-value += parse-int ($ checkbox).val!
        permission-value
    
    _set-checkbox-checked = (checkbox-par)!->
        ($ checkbox-par.find "> input[type='checkbox']").attr 'checked',true
        checkbox-par.remove-class "unchecked-icon"
        checkbox-par.add-class "checked-icon"
    
    _set-checkbox-unchecked = (checkbox-par)!->
        ($ checkbox-par.find "> input[type='checkbox']").attr 'checked',false
        checkbox-par.remove-class "checked-icon"
        checkbox-par.add-class "unchecked-icon"
    
    _cancel-btn-click-event = !->
        _reset-dom!
        page.toggle-page "main"
    
    _save-btn-click-event = !->
        console.log _get-permission-value!
        _reset-dom!
        page.toggle-page "main"

    _init-depend-module = !->
        page := require "./pageManage.js"
        
    _init-event = !->
        _cancel-btn-dom.click !-> _cancel-btn-click-event!
        _save-btn-dom.click !-> _save-btn-click-event!
        _checkbox-dom.click !-> _checkbox-click-event event

    initial: !->
        _init-depend-module!
        _init-event!

module.exports = new-manage
