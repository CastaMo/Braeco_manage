require_ = require "../requireManage.js"

class MoveController
	(options)->
		@assign options
		@init!

	assign: (options)!->
		@all-default-states = options.all-default-states

	init: !->
		@init-all-prepare!
		@set-default-state!

	init-all-prepare: !->
		@current-category-id = null

	set-default-state: !->
		default-category-id 	= @all-default-states.shift!.default-category-id
		@current-category-id 	= default-category-id

	get-current-category-id: !-> return @current-category-id

	set-current-category-id: (category-id)!-> @current-category-id = category-id

	require-for-move: (current-combo-ids, new-category-id, callback)!->
		_get-upload-JSON-for-move = (current-combo-ids, new-category-id)->
			request-object = {}
			for id in current-combo-ids
				request-object[id] = new-category-id
			return JSON.stringify request-object

		require_.get("move").require {
			data 				:		 	{
				JSON 			:			_get-upload-JSON-for-move current-combo-ids, new-category-id
			}
			success 		: 		callback
		}

module.exports = MoveController
