page-manage = let

    $("\#Staff-sub-menu").addClass "choose"
    $("\#staff-nav li\#Role").addClass "choose"
    
    
    _main-dom = $ "\#staff-role-main"
    _new-dom = $ "\#staff-role-new"
    _edit-dom = $ "\#staff-role-edit"
    
    _all-toggle-dom = [_main-dom, _new-dom, _edit-dom]
    
    _unshow-all-toggle-dom-except-given = (dom_)->
        for dom in _all-toggle-dom when dom isnt dom_
            dom.fade-out 100
    
    _toggle-page-callback = {
        "main"      :       let
            ->
                $("html, body").animate { scrollTop: 0 },1
                set-timeout (-> _main-dom.fade-in 100), 100
                _unshow-all-toggle-dom-except-given _main-dom
        "new"       :       let
            ->
                $("html, body").animate { scrollTop: 0 },1
                set-timeout (-> _new-dom.fade-in 100), 100
                _unshow-all-toggle-dom-except-given _new-dom

        "edit"      :       let
            ->
                $("html, body").animate { scrollTop: 0 },1
                set-timeout (-> _edit-dom.fade-in 100), 100
                _unshow-all-toggle-dom-except-given _edit-dom
    }
    
    initial: ->
    
    toggle-page: (page)->
        _toggle-page-callback[page]?!
    
module.exports = page-manage
