page = null
edit-manage = let

    

    _init-all-event = !->
        

    _init-depend-module = !->
        page 	:= require "./pageManage.js"

    initial: !->
        _init-depend-module!
        _init-all-event!

module.exports = edit-manage