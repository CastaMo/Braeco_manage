CBase = require "../Utils/CBase.js"

class SubitemModifyController extends CBase
	(options)-> super options

	assign: (options)!->
		@subitem-modify-model = options.subitem-modify-model
		@subitem-model 				= options.subitem-model
		@dish-model 					= options.dish-model

	set-is-all-choose: (is-choose)!->
		@subitem-modify-model.set-is-all-choose is-choose

	get-is-all-choose: ->
		return @subitem-modify-model.get-is-all-choose!

	set-is-category-choose: (category-id, is-choose)!->
		@subitem-modify-model.set-is-category-choose category-id, is-choose

	set-is-category-active: (category-id, is-active)!->
		@subitem-modify-model.set-is-category-active category-id, is-active

	get-is-category-choose: (category-id)->
		return @subitem-modify-model.get-is-category-choose category-id

	get-is-category-active: (category-id)->
		return @subitem-modify-model.get-is-category-active category-id

	set-is-dish-choose: (category-id, dish-id, is-choose)!->
		@subitem-modify-model.set-is-dish-choose category-id, dish-id, is-choose

	get-is-dish-choose: (category-id, dish-id)->
		return @subitem-modify-model.get-is-dish-choose category-id, dish-id


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

module.exports = SubitemModifyController
