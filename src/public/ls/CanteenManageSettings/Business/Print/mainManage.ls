main-manage = let
	[get-JSON, deep-copy] = [util.get-JSON, util.deep-copy]
	page = null

	_init-all-event = !->


	_init-depend-module = !->
		page := require "./pageManage.js"

	initial: !->
		_init-all-event!
		_init-depend-module!

module.exports = main-manage
