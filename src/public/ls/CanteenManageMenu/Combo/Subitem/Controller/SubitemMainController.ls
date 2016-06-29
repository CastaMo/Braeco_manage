CBase = require "../Utils/CBase.js"
require_ = require "../requireManage.js"

class SubitemMainController extends CBase
	(options)-> super options

	assign: (options)!->
		@subitem-model = options.subitem-model

	remove-subitem-by-id: (subitem-id)!->
		@subitem-model.remove-subitem-by-id subitem-id

	get-subitem-by-id: (subitem-id)-> return @subitem-model.get-subitem-by-id subitem-id

	submit-data-and-try-require: (subitem-id, callback, always)!->
		config-data-for-upload = @subitem-model.get-config-data-for-upload subitem-id
		config-data-for-callback = @subitem-model.get-config-data-for-callback subitem-id
		@require-for-remove-subitem config-data-for-upload, config-data-for-callback, callback, always

	require-for-remove-subitem: (config-data-for-upload, config-data-for-callback, callback, always)!->
		require_.get("remove").require {
			data 	 		: 		config-data-for-upload
			success 	: 		(result)!~>
				@subitem-model.remove-subitem-by-id config-data-for-callback.id
				callback?!
			always 		: 		!-> always?!
		}

module.exports = SubitemMainController