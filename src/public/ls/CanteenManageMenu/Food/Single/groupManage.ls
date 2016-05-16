new_ = page = null

group-manage = let
	
	[		deep-copy, 			get-JSON] = 
		[	util.deep-copy,		util.get-JSON]

	_properies = {}
	_groups = {}

	_init-depend-module = !->
		new_ 	:= require "./newManage.js"
		page 	:= require "./pageManage.js"

	_init-all-event = !->

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
		console.log _groups

	class Group

		(options)->
			deep-copy options, @
			@init!
			_groups[@id] = @

		init: !->

	class Property extends Group

		_property-content-list-dom  		= $ "\#full-cover ul.property-content-list"

		(options)->
			super options, @
			_properies[@id] = @

		init: !->
			@init-all-prepare!
			@init-all-dom!
			@init-all-event!

		init-all-prepare: !->
			@active = false

		init-all-dom: !->
			@init-property-content-dom!

		init-all-event: !->
			@property-content-dom.click !~>
				if @active then @inactive-self!
				else @active-self!

		init-property-content-dom: !->
			_get-property-content-dom = (property)->
				dom = $ "<li class='property-content'>
							<div class='property-content-wrapper'>
								<div class='name-field'>
									<p class='name'>#{property.name}</p>
								</div>
								<div class='tick-field'>
									<div class='tick'></div>
								</div>
								<div class='clear'></div>
							</div>
						</li>"
				_property-content-list-dom.append dom
				return dom

			@property-content-dom = _get-property-content-dom @

		active-self: !-> @active = true; @property-content-dom.add-class "active"

		inactive-self: !-> @active = false; @property-content-dom.remove-class "active"

		reset: !-> inactive-self!

		@reset-all = !->
			for id, property of _properies
				property.reset!
		@active-property-by-array-id = (array-id)!->
			@reset-all!
			for id in array-id
				try
					_properies[id].active-self!
				catch error
					alert "管理端与后台未同步，请先刷新"

		@get-current-active-array = -> return [id for id, property of _properies when property.active]

	initial: (_get-group-JSON)!->
		_init-depend-module!
		_init-all-event!
		_init-all-group _get-group-JSON

	get-group-name-by-id: (id)-> if _groups[id] then return _groups[id].name else return ""

	get-group-type-by-id: (id)-> if _groups[id] then return _groups[id].type else return ""


module.exports = group-manage