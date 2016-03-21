module.exports = let

	_state = null

	$("\#Category-sub-menu").addClass "choose"

	_mainDom = $ "\#category-main"
	_newDom = $ "\#category-new"
	_editDom = $ "\#category-edit"
	_allDom = [_mainDom, _newDom, _editDom]

	_unshowAllDomExceptGiven = (dom_)->
		for dom in _allDom when dom isnt dom_
			dom.fade-out 200

	initial: ->