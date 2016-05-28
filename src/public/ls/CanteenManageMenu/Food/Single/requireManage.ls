require-manage = let

	[		get-JSON,		ajax,		deep-copy] 		= 
		[	util.get-JSON, 	util.ajax,	util.deep-copy]

	###
	#	请求名字(自己设)
	###
	_all-require-name = [
		'add',							'copy',
		'remove',						'top',
		'move', 						'edit',
		'able', 						'picUploadPre',
		'picUpload'
	]

	###
	#	请求名字与URL键值对(与后台进行商量)，名字需依赖于上述对象
	###
	_all-require-URL = {
		'add' 			:		'/Dish/Add'
		'copy' 			:		'/Dish/Copy'
		'remove' 		:		'/Dish/Remove'
		'top' 			:		'/Dish/Update/Top'
		'move' 			:		'/Dish/Update/Category'
		'edit' 			:		'/Dish/Update/All'
		'able' 			:		'/Dish/Update/Able'
		'picUploadPre' 	:		'/pic/upload/token/dishupdate'
		'picUpload' 	:		'http://up.qiniu.com/putb64'
	}

	_requires = {}


	###
	#	ajax请求基本配置，无特殊情况不要改
	###
	_default-config = {
		async 	:	true
		type 	:	"POST"
	}

	###
	#	获取一个基本的ajax请求对象，主要有url、type、async的配置
	###
	_get-normal-ajax-object = (config)->
		return {
			url 		:		config.url
			type 		:		config.type
			async 		:		config.async
		}

	###
	#	校正ajax-object的url
	###
	_correct-URL = {
		"add"			:		(ajax-object, data)-> ajax-object.url += "/#{data.category-id}"
		"edit" 			:		(ajax-object, data)-> ajax-object.url += "/#{data.dish-id}"
		"able" 			:		(ajax-object, data)-> ajax-object.url += "/#{data.flag}"
		'picUploadPre' 	:		(ajax-object, data)-> ajax-object.url += "/#{data.id}"
		'picUpload' 	:		(ajax-object, data)-> ajax-object.url += "/#{data.fsize}/key/#{data.key}"
	}


	###
	#	按照需要设定header
	###
	_set-header = {
		"picUpload" 		:		(ajax-object, data)-> ajax-object.header =  {
			"Content-Type" 		:		"application/octet-stream"
			"Authorization" 	:		"UpToken #{data.token}"
		}
	}


	###
	#	ajax请求对象对应的数据请求属性，以键值对Object呈现于此
	###
	_get-require-data-str = {
		"add" 			:		(data)-> return "#{data.JSON}"
		"copy" 			:		(data)-> return "#{data.JSON}"
		"remove" 		:		(data)-> return "#{data.JSON}"
		"top" 			: 		(data)-> return "#{data.JSON}"
		"move" 			:		(data)-> return "#{data.JSON}"
		"edit" 			:		(data)-> return "#{data.JSON}"
		"able" 			:		(data)-> return "#{data.JSON}"
		"picUploadPre" 	:		(data)-> return ""
		"picUpload" 	:		(data)-> return "#{data.url}"

	}


	###
	#	在状态码为200，即请求成功返回时的处理
	#	@{param}	name: 		请求对象的名字
	#	@{param}	result_:	返回值，即ResponseText
	#	@{param}	callback:	当返回的message为success时执行的回调函数
	###
	_normal-handle = (name, result_, callback)->
		result = get-JSON result_
		message = result.message
		if message is "success" then callback?(result)
		else if message then _require-fail-callback[name][message]?!
		else alert "系统错误"


	###
	#	在请求状态码为200且返回的message属性不为success时的处理方法
	###
	_require-fail-callback = {
		"add"			:		{
			"Category not found" 						:	-> alert "品类不存在"
			"Conflict property name" 					: 	-> alert "一个单品所包含的所有属性组不得有重名的属性存在"
		}
		"copy" 			:		{}
		"remove" 		:		{}
		"top" 			:		{}
		"move" 			:		{}
		"edit" 			:		{}
		"able" 			:		{}
		"picUploadPre" 	:		{
			"Dish not found" 							:	-> alert "餐品不存在!"
		}
		"picUpload" 	:		{
			
		}
	}


	###
	#	用于获取每个请求对象的require函数方法
	#	@param	{String}	name:		请求对象的名字
	#	@param	{Object}	config:		请求的基本配置
	#	@return	{Fn}					执行ajax请求，需要依赖于上面的函数方法
	###
	_require-handle = (name, config)->
		return (options)->
			ajax-object = _get-normal-ajax-object config
			ajax-object.data = _get-require-data-str[name]? options.data
			_correct-URL[name]? ajax-object, options.data
			_set-header[name]? ajax-object, options.data
			ajax-object.success = (result_)-> _normal-handle name, result_, options.callback
			ajax-object.always = options.always
			ajax ajax-object


	class Require

		(options)->
			deep-copy options, @
			@init()
			_requires[@name] = @

		init: ->
			@init-require!

		init-require: ->
			config = {}
			deep-copy _default-config, config
			config.url = @url
			@require = _require-handle @name, config

	_init-all-require = ->
		for name, i in _all-require-name
			require = new Require {
				name 		:		name
				url 		:		_all-require-URL[name]
			}


	get: (name)-> return _requires[name]

	initial: ->
		_init-all-require!
module.exports = require-manage
