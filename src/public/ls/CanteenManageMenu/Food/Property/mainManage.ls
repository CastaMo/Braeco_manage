page = null

main-manage = let
	[ 		deep-copy, 			get-JSON] =
		[	util.deep-copy, 	util.get-JSON]

	_properties 							= {}
	_groups 								= {}

	_new-btn-dom 		= $ ".property-new-btn-field .new-btn"

	_init-depend-module = !->
		page 		:= require "./pageManage.js"

	_init-all-event = !->

		_new-btn-dom.click !-> _new-btn-click-event!

	_init-all-group = (_get-group-JSON)!->
		all-groups = get-JSON _get-group-JSON!
		console.log all-groups
		for group in all-groups
			if group.type is "property" then property = new Property {
				id 			:		group.id
				name 		:		group.name
				content 	: 		group.content
				belong-to 	:		group.belong_to
			}
		console.log _properties

	_new-btn-click-event = !-> page.toggle-page "new"

	class Group

		(options)->
			deep-copy options, @
			@init!
			_groups[@id] = @

		init: !->

	class Property extends Group
		(options)->
			super options, @
			_properties[@id] = @

		init: !->
			@init-all-dom!
			@init-all-event!

		init-all-dom: !->
			@init-property-dom!
			@init-all-detail-dom!

		init-all-event: !->

		init-property-dom: !->


		init-all-detail-dom: !->
			

	initial: (_get-group-JSON)!->
		_init-depend-module!
		_init-all-event!
		_init-all-group _get-group-JSON

module.exports = main-manage