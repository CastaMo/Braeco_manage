page-manage = let
	_state = null

	$("\#Hall-Order-sub-menu").addClass "choose"
	$("\#Hall-Order-nav li\#Basic").addClass "choose"

	_toggle-page-callback = {

	}


	initial: ->

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage
