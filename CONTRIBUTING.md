#路由配置

1. 首先URL根路径必须添加/Manage，这是为了配合后台Nginx的配置。

2. 其次按照侧栏的分级菜单进行填充，按照/#{一级名称}/#{二级名称}的格式对URL进行填充

3. 如果主栏里还有分级页面，则按照/#{主栏分级名称}进行填充

####对于每个页面模块，在未开发的情况下侧栏对应的跳转button的href均为#，需要自己手动改

####文件路径放置基于路由配置



#html(jade)编写

1. 需要注意先继承导航栏和侧栏layout.jade，位于jade的根目录中。

2. 页面模块的主jade文件命名为index.jade，先保留标签不填。

3. develop.jade用于开发者使用的标签填充，formal.jade用于正式发布的标签填充(包含压缩以及版本号)

#js(ls)编写

1. 需注意，本项目采用了browserify作模块化的管理，index.ls应是所有模块启动的主文件，它在编译成js之后会通过browserify转成main.js。

2. index.ls的初始化函数为_test-is-data-ready，用于请求数据以及初始化模块，直接在声明的后面调用即可。而其他模块的初始化函数均为initial，且为公开的，可有参数传递(要用到请求的数据时，传递一个函数来获取对应的数据)

3. 最好区分公有化与私有化。

## 在lib/public/js/common中有一个util.js，这个是平时收集的一些实用函数的整合，deepCopy这个深拷贝函数经常会用到。

#css(less)编写

1. 保证两个文件，一个是main.less，一个是base64.less，main.less需要先导入common.less文件，用于配置继承原来的模块的样式，base64.less用于放置小图标的base64字符串。

-

#grunt配置

1. 在新建一个页面模块的时候，需要在jade、less、livescript、browserify、watch、uglify、cssmin、中添加子项，路径可以结合路径配置和参考已配好的子项。如果不明白直接联系。

-
