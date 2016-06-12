let win = window, doc = document
    [getJSON] = [util.getJSON]

    _get-staff-JSON = null
    _get-role-JSON = null

    _init-callback = {
        "Need to rescan qrcode"     :   ->  win.location.pathname = "/Table/Confirm/rescan"
        "success"                   :   (result)->
            _init-all-get-JSON-func result.data
            _init-all-module()
    }

    _init-all-get-JSON-func = (data)->
        _get-staff-JSON := -> return JSON.stringify(data.waiters)
        _get-role-JSON := -> return JSON.stringify(data.roles)


    _main-init = (result)->
        _init-callback[result.message]?(result)

    _init-all-module = !->
        page = require "./pageManage.js";           page.initial!
        main = require "./mainManage.js";           main.initial _get-staff-JSON,_get-role-JSON
        new-page  = require "./newManage.js";       new-page.initial!
        edit-page = require "./editManage.js";      edit-page.initial!

    _test-is-data-ready = ->
        if window.all-data then _main-init JSON.parse window.all-data; window.all-data = null;
        else window.main-init = _main-init

    _test-is-data-ready!
