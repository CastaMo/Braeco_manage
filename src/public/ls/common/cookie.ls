_cookie = !->
	map-auth-for-key = {
		#菜单管理
		1 				: 		{
			desc 								: 		"编辑餐牌"
			un-match-callback 	: 	!->
			name 								: 	"MENU_EDIT"
		}
		2 				: 		{
			desc 								: 	"隐藏、显示、移动、排序餐品或品类"
			un-match-callback 	: 	!->
			name 								: 	"MENU_OAM"
		}
		4 				: 		{
			desc 								: 	"单品优惠"
			un-match-callback 	: 	!->
			name 								: 	"MENU_DISCOUNT"
		}
		8 				: 		{
			desc 								: 	"(待定)"
			un-match-callback 	:	 	!->
			name 								:	 	"Braeco-0"
		}
		#营销管理
		16 				: 		{
			desc 								: 	"活动管理(新建、编辑、删除)"
			un-match-callback 	: 	!->
				$ "\#Activity-sub-menu" .remove!
			name 								: 	"MARKET_ACTIVITY"
		}
		32 				: 		{
			desc 								: 	"订单优惠"
			un-match-callback 	: 	!->
				$ "\#Order-sub-menu" .remove!
			name 								: 	"MARKET_DCTOOL"
		}
		64 				:			{
			desc 								: 	"会员(会员设置 会员充值 修改积分 的前置权限)"
			un-match-callback 	:		!->
				$ "\#Discount-sub-menu" .remove!
			name 								: 	"MARKET_MEMBER"
		}
		128 			: 		{
			desc 								: 	"卡券"
			un-match-callback 	: 	!->
				$ "\#Card-sub-menu" .remove!
			name 								:		"MARKET_COUPON"
		}
		256 			: 		{
			desc 								: 	"会员设置(修改'等级折扣'与'充值项'阶梯)"
			un-match-callback 	:	 	!->
			name 								: 	"MARKET_MEMBER_LADDER"
		}
		512 			: 		{
			desc 								: 	"(待定)"
			un-match-callback 	:	 	!->
			name 								:		"Braeco-1"
		}
		1024 			: 		{
			desc 								: 	"(待定)"
			un-match-callback 	: 	!->
			name 								: 	"Braeco-2"
		}
		#数据管理
		2048 			: 		{
			desc 								:	 	"流水订单(退款、重打、的前置权限)"
			un-match-callback 	: 	!->
				$ "\#WaterOrder-sub-menu" .remove!
			name 								: 	"DATA_ORDERS"
		}
		4096 			: 		{
			desc 								: 	"数据统计(打印日结的前置权限)"
			un-match-callback 	:	 	!->
				$ "\#Data-sub-menu" .remove!
			name 								: 	"DATA_STATISTIC"
		}
		8192 			: 		{
			desc 								: 	"营销分析"
			un-match-callback 	: 	!->
				$ "\#Market-Analysis-sub-menu" .remove!
			name 								: 	"DATA_ANALYSIS"
		}
		16384 		: 		{
			desc 								: 	"(待定)"
			un-match-callback 	: 	!->
			name 								: 	"Braeco-4"
		}
		32768 		: 		{
			desc 								: 	"(待定)"
			un-match-callback 	:	 	!->
			name 								: 	"Braeco-5"
		}
		#餐厅管理
		65536			: 		{
			desc 								: 	"业务管理(堂食、外卖、预点)"
			un-match-callback 	: 	!->
				$ "\#Business-sub-menu" .remove!
			name 								: 	"MANAGE_FIRM"
		}
		131072 		: 		{
			desc 								: 	"店员管理(只有管理员有此权限)"
			un-match-callback 	: 	!->
				$ "\#Staff-sub-menu" .remove!
			name 								: 	"MANAGE_WAITER"
		}
		262144 		: 		{
			desc 								: 	"餐厅信息修改"
			un-match-callback 	: 	!->
				$ "li\#canteen-info-field" 	.parent "a"
																		.attr {"href":"#"}
			name 								: 	"MANAGE_BASIC_INFO"
		}
		524288 		: 		{
			desc 								: 	"餐厅日志"
			un-match-callback 	: 	!->
				$ "li\#canteen-log-field" 	.parent "a"
																		.attr {"href":"#"}
			name 								: 	"MANAGE_LOG"
		}
		1048576 	: 		{
			desc 								: 	"(待定)"
			name 								: 	"Braeco-6"
		}
		2097152 	: 		{
			desc 								: 	"(待定)"
			name 								: 	"Braeco-7"
		}
		#日常经营
		4194304 	: 		{
			desc 								:		"接单处理"
			name 								: 	"OPERATION_RECIEVE_ORDER"
		}
		8388608 	: 		{
			desc 								: 	"辅助点餐"
			name 								: 	"OPERATION_PLACE_ORDER"
		}
		16777216 	: 		{
			desc 								: 	"会员充值"
			name 								: 	"OPERATION_MEMBERSHIPCARD_CHARGE"
		}
		33554432 	: 		{
			desc 								: 	"修改积分"
			name 								:		"OPERATION_MEMBERSHIPCARD_SETEXP"
		}
		67108864 	: 		{
			desc 								: 	"退款"
			name 								: 	"OPERATION_REFUND"
		}
		134217728 : 		{
			desc 								: 	"重打某单"
			name 								:		"OPERATION_REPRINT"
		}
		268435456 : 		{
			desc 								: 	"打印日结"
			name 								: 	"OPERATION_PRINT_DAILY_STATISTIC"
		}
		536870912	: 		{
			desc 								: 	"(待定)"
			name 								: 	"Braeco-8"
		}
		1073741824: 		{
			desc 								: 	"(待定)"
			name 								: 	"Braeco-9"
		}
	}

	get-cookie-array = !->
		str = document.cookie.replace(" ","")
		return str.split(";")

	get-value-by-key = (key, cookie-array)!->
		for cookie in cookie-array
			if cookie.index-of(key) is 0
				return cookie.replace "#{key}=", ""
			return ""

	get-auth-by-value = (value) !->
		value = Number value
		auth = {}
		for key, obj of map-auth-for-key
			is-match = !!(Number(key) .&. value)
			if not is-match
				obj.un-match-callback?!
			auth[obj.name] = is-match
		return auth

	cookie-array = get-cookie-array!
	value = (get-value-by-key "auth", cookie-array) || "2147483647"
	auth = get-auth-by-value value
	console.log cookie-array, value, auth