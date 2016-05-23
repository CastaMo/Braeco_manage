page = null
main-manage = let

    _new-button-dom = $ ".psm-header-new-button"

    _new-dom  =  $ '\#promotion-single-new'
    
    _new-btn-click-event = !->
        page.toggle-page "new"
   
    _init-all-event = !->
        console.log 'new button'
        _new-button-dom.click !-> _new-btn-click-event!
        
    _init-depend-module = !->
        page 	:= require "./pageManage.js"

    initial: !->
        _init-depend-module!
        _init-all-event!


module.exports = main-manage