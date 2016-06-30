CBase 		= require "../Utils/CBase.js"
require_ 	= require "../requireManage.js"

class SubitemModifyController extends CBase
	(options)-> super options

	assign: (options)!->
		@subitem-modify-model = options.subitem-modify-model
		@subitem-model 				= options.subitem-model
		@dish-model 					= options.dish-model

	# set-is-all-choose: (is-choose)!->
	# 	@subitem-modify-model.set-is-all-choose is-choose

	# get-is-all-choose: ->
	# 	return @subitem-modify-model.get-is-all-choose!

	# set-is-category-choose: (category-id, is-choose)!->
	# 	@subitem-modify-model.set-is-category-choose category-id, is-choose

	# set-is-category-active: (category-id, is-active)!->
	# 	@subitem-modify-model.set-is-category-active category-id, is-active

	# get-is-category-choose: (category-id)->
	# 	return @subitem-modify-model.get-is-category-choose category-id

	# get-is-category-active: (category-id)->
	# 	return @subitem-modify-model.get-is-category-active category-id

	# set-is-dish-choose: (category-id, dish-id, is-choose)!->
	# 	@subitem-modify-model.set-is-dish-choose category-id, dish-id, is-choose

	# get-is-dish-choose: (category-id, dish-id)->
	# 	return @subitem-modify-model.get-is-dish-choose category-id, dish-id

	toggle-is-all-choose: !->
		is-choose = @subitem-modify-model.get-is-all-choose!
		@subitem-modify-model.set-is-all-choose !is-choose

	toggle-is-category-active: (category-id)!->
		is-active = @subitem-modify-model.get-is-category-active category-id
		@subitem-modify-model.set-is-category-active category-id, !is-active

	toggle-is-category-choose: (category-id)!->
		is-choose = @subitem-modify-model.get-is-category-choose category-id
		@subitem-modify-model.set-is-category-choose category-id, !is-choose

	toggle-is-dish-choose: (category-id, dish-id)!->
		is-choose = @subitem-modify-model.get-is-dish-choose category-id, dish-id
		@subitem-modify-model.set-is-dish-choose category-id, dish-id, !is-choose

	toggle-to-add-subitem: !->
		@subitem-modify-model.set-state "new"
		@subitem-modify-model.reset!

	toggle-edit-subitem-by-id: (subitem-id)!->
		@subitem-modify-model.set-state "edit"
		@subitem-modify-model.reset!
		subitem = @subitem-model.get-subitem-by-id subitem-id
		for dish-id in subitem.content
			category-id = @dish-model.get-category-id-by-dish-id dish-id
			@subitem-modify-model.set-is-dish-choose category-id, dish-id, true
			@subitem-modify-model.set-is-category-active category-id, true
		@subitem-modify-model.read-from-subitem subitem

	submit-data-and-try-require: (config-data, callback, always, require-prepare-callbcak)!->
		@subitem-modify-model.set-config-data config-data
		@subitem-modify-model.update-all-choose-dish-ids!
		if not @subitem-modify-model.check-self-config-data-is-valid! then return
		config-data-for-upload = @subitem-modify-model.get-config-data-for-upload!
		config-data-for-callback = @subitem-modify-model.get-config-data-for-callback!
		console.log config-data-for-upload, config-data-for-callback
		require-prepare-callbcak?!
		if @subitem-modify-model.get-state! is "new"
			@require-for-add-subitem config-data-for-upload, config-data-for-callback, callback, always
		else if @subitem-modify-model.get-state! is "edit"
			@require-for-update-subitem config-data-for-upload, config-data-for-callback, callback, always

	require-for-add-subitem: (config-data-for-upload, config-data-for-callback, callback, always)!->
		require_.get("add").require {
			data 		: 		config-data-for-upload
			success : 		(result)!~>
				config-data-for-callback.id = result.id
				@subitem-model.add-subitem config-data-for-callback
				callback?!
			always 	: 		!-> always?!
		}

	require-for-update-subitem: (config-data-for-upload, config-data-for-callback, callback, always)!->
		require_.get("edit").require {
			data 		: 		config-data-for-upload
			success : 		(result)!~>
				@subitem-model.update-subitem config-data-for-callback.id, config-data-for-callback
				callback?!
			always 	: 		!-> always?!
		}

module.exports = SubitemModifyController
