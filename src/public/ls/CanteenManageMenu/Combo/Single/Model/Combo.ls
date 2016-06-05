eventbus 		= require "../eventbus.js"

[ 		deep-copy] = 
	[		util.deep-copy]

class Combo

	(options)->
		@assign options

	assign: (options)!->
		@able  						= 		options.able 						|| true
		@dc 							= 		options.dc 							|| 0
		@dc-type 					= 		options.dc_type 				|| "none"
		@default-price 		= 		options.default_price
		@detail 					= 		options.detail 					|| ""
		@groups 					= 		options.groups 					|| []
		@id 							= 		options.id
		@c-name 					= 		options.name
		@e-name 					= 		options.name2 					|| ""
		@pic 							= 		options.pic 						|| ""
		@type 						= 		options.type

	set-able: (able)!->
		@able = able
		eventbus.emit("model:combo:able-change", @id, @able)

	set-config: (options)!->
		deep-copy options, @
		eventbus.emit("model:combo:config-change", @id, options)

	get-c-name: -> return @c-name

	get-e-name: -> return @e-name

	get-pic: -> return @pic

	get-default-price: -> return @default-price

	get-groups: -> return @groups

	get-dc-type: -> return @dc-type

	get-dc: -> return @dc

	get-detail: -> return @detail

	get-able: -> return @able

	get-type: -> return @type


module.exports = Combo