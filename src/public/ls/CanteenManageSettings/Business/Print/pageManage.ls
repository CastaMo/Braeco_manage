page-manage = let
	main = null
	$("\#Business-sub-menu").addClass "choose"
	$("\#Business-nav li\#Print").addClass "choose"

	_toggle-page-callback = {

	}

	_init-depend-module = !->
		main := require "./mainManage.js"

	initial: ->
		_init-depend-module!

	toggle-page: (page)->
		_toggle-page-callback[page]?!
		set-timeout "scrollTo(0, 0)", 0

module.exports = page-manage
