CBase = require "../Utils/CBase.js"

class SubitemMainController extends CBase
	(options)-> super options

	assign: (options)!->
		@subitem-model = options.subitem-model

	remove-subitem-by-id: (subitem-id)!->
		@subitem-model.remove-subitem-by-id subitem-id

	get-subitem-by-id: (subitem-id)-> return @subitem-model.get-subitem-by-id subitem-id


module.exports = SubitemMainController