# 'use strict';

# ActivityModel类，利用localStorage存储数据，实现MV之间的双向数据绑定

class Model
	->
		@data = []
		@action!

	action: !->
		console.log 'This is model action!'

module.exports = Model
