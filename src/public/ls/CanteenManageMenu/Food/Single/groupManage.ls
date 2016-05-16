new_ = page = null

group-manage = let
	
	[		deep-copy, 			get-JSON] = 
		[	util.deep-copy,		util.get-JSON]

	_groups = {}

	_init-depend-module = !->
		new_ 	:= require "./newManage.js"
		page 	:= require "./pageManage.js"

	_init-all-event = !->

	_init-all-group = (_get-group-JSON)!->
		all-groups = get-JSON _get-group-JSON!
		console.log all-groups

	class group

		(options)->
			deep-copy options, @
			@init!
			_groups[@id] = @

		init: !->
			@init-all-dom!
			@init-all-event!

		init-all-dom: !->


		init-all-event: !->

	initial: (_get-group-JSON)!->
		_init-depend-module!
		_init-all-event!
		_init-all-group _get-group-JSON


module.exports = group-manage