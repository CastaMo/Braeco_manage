MBase 		= require "../Utils/MBase.js"
Base 			= require "../Utils/Base.js"
eventbus 	= require "../eventbus.js"

class Subitem extends Base
	(options)-> super options

	assign: (options)!->
		@belong-to 	= options.belong-to
		@content 		= options.content
		@id 				= Number options.id
		@name 			= options.name
		@remark 		= options.remark
		@type 			= options.type
		@price 			= options.price
		@discount 	= options.discount



class SubitemModel extends MBase

	(options)-> super options

	assign: (options)!->
		@datas 	= 	options.datas

	init-all-prepare: !->
		@all-subitems = {}
		@current-subitem-id = null

	init-all-datas: !->
		for data in @datas when data.type isnt "property"
			@add-subitem {
				belong-to 		: 		data.belong_to
				content 			:			data.content
				id 						:			data.id
				name 					:			data.name
				remark 				:			data.remark
				type 					:			data.type
				price 				:			data.price 		|| 0
				discount 			: 		data.discount || 0
			}
		console.log @all-subitems

	add-subitem: (subitem)!->
		subitem = new Subitem subitem
		@all-subitems[subitem.id] = subitem
		eventbus.emit "model:subitem:add-subitem", subitem.id

	remove-subitem-by-id: (subitem-id)!->
		delete @all-subitems[subitem-id]
		eventbus.emit "model:subitem:remove-subitem", subitem-id

	update-subitem: (subitem-id, config-data)!->
		@all-subitems[subitem-id].assign config-data
		eventbus.emit "model:subitem:update-subitem", subitem-id

	get-subitem-by-id: (subitem-id)-> return @all-subitems[subitem-id]

	get-config-data-for-upload: (subitem-id)->
		result = {}
		result.group-id = subitem-id
		return result

	get-config-data-for-callback: (subitem-id)->
		obj = {}
		obj.id = subitem-id
		return obj

module.exports = SubitemModel

