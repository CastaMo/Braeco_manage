# AngularJS 开发规范

> 吴家荣

## 1 开发步骤

垂直的web开发涉及前端，服务端，数据库。

全栈人员的开发步骤一般是：前端->服务端。先写好前端基本界面，再写数据接口跟服务端进行对接。

直接的前端工程师只需要接口，并且和后台工程师进行必要的沟通即可。

前端遵循的规范是：`SOC`，`Separation of concerns`。也就是，`html`负责结构->`css`负责样式->`js`负责行为。不要在`html`里面写`css`或`js`。

* 先安排好`angular`路由，对应到自己要写的`view`，其实也就是在`application.ls`配置一下`$routeProvider`服务
* 然后就开始写`*.client.view.jade`，注意`*`命名应该是名词。
* 写`jade`的时候，注意设计好结构，具体规范请看*4 Jade开发规范*
* 写`jade`觉得差不多了，就可以写`sass`了，`sass`具体开*5 Sass开发规范*
* 页面基本有了以后，可以开始写`ls`了。`ls`具体看*6 LiveScript开发规范*和*7 AngularJS开发规范*
* 前端的结构样式行为都搞定了，这时候就开始编写服务端接口吧。具体请看*8 ExpressJS开发规范*
* 好了，如果你觉得基本完成功能了，而且自己测试没有发现明显的bug的时候，就可以开始写测试了，测试具体参考*9 测试*
* 搞定觉得测试也没问题了，就把你的代码推到`web-serivce`进行合并，我也会看一下你的代码，如果觉得没问题会部署上线进行公开测试的。

## 2 Jade开发规范

* 可以使用`class`的尽量使用`class`，`id`尽量少用，最好是在大模块上才使用`id`
* `class`和`id`要用名词，不要使用动词。
* `class`和`id`使用嵌套写法。
* `class`和`id`注意要使用横杠命名法，不要驼峰和下划线。
* 两个角色：`wrapper`和`container`，`wrapper`负责控制外部的`margin`，`container`负责控制内部的`padding`。每一个涉及`margin`和`padding`都需要这样子做。
* 其他结构的命名，自己设计就好。注意善用`class`和`id`
* Jade开发规范化，使用HTML提供的原生的元素实现该实现的功能，如表单功能，虽然用`div`也可以实现，但是不规范，我们能用`Form`的就用`Form`。其他例子依次类推。

## 3 Less开发规范

* `class`和`id`统一使用嵌套写法，能嵌套的尽量嵌套。
* 如果是原子类，就独立出来。
* 每一个大板块前面要写好注释。
* 善用`sass`提供的变量。
* 嵌套属性的写法是：与外层选择器相关的属性放最上面，接着按照`jade`的结构和嵌套方式从上往下排列。

## 4 LiveScript开发规范

### 4.1 LiveScript变量，函数命名规范

* JS基本变量和引用变量都使用`名词`进行命名
  * 如：`problem`，`assignment`等，考虑单复数
* JS函数命名使用`动名词`进行命名
  * 如果是网络请求操作统一使用`CRUD`（`create, retrieve, update, delete`增删改查）进行命名：如`retrieve-a-problem`，`create-a-problem`，`update-a-problem`，`delete-a-problem`
* JS函数命名可以适当增加副词，以增强可读性，但不能多，避免冗余
  * 如`set-code-editor-by-id`

### 4.2 不在Controller里面直接写操作语句

任何直接运行的原子操作语句都不要直接写在`Controller`里面，要用函数封装起来。

封装类型如下：

* `$scope`变量初始化
  - 统一命名为：`init-scope-variable`，用来初始化`$scope`变量
* `$rootScope`变量初始化
  - 统一命名为：`init-rootScope-variable`，用来初始化`$scope`变量
* `$resource`变量初始化
  - 理论上`$resource`变量不应该放在`$scope`里面的，但是为了管理方便，统一放在`$scope.resource`对象下面，初始化函数统一为：`init-resource-variable`
* 页面元素初始化
  - 统一命名为：`init-page-dom`，用来在页面加载的时候`DOM`的初始化
* 接下来是`$scope`事件函数定义，统一放在一个区域
  - 命名方式参考6.1
* 然后是工具函数定义，工具函数的意思就是完成一些功能的函数，其实*`$scope`变量初始化*和*`$rootScope`变量初始化*和*`$resource`变量初始化*，都是工具函数，都应该放在工具函数的定义区域。但是为了更好的理解性和刻度性，我决定把*`$scope`变量初始化*和*`$rootScope`变量初始化*和*`$resource`变量初始化*放在`controller`顶部。
* 最后的区域是需要马上执行的函数的执行，执行需要注意前后顺序。这个使用，那些`init-*`函数就在这个区域执行。

### 4.3 注释

要注意，对于LS代码来说，如果相关操作比较复杂，注释是必要的。但是要是看到变量名或者函数名就知道是干嘛的话，就不用注释了。

所以注意要写好注释。

我们的注释没有比较严格的规范，基本就是你个人感觉需要写注释的地方，就写注释。中英文均可，关键是你要确保别人能看懂。

js代码不需要生成类似`java doc`这样的东西，所以，注释不要求格式。

## 5 AngularJs开发规范

### 5.1 Controller内部$resource命名规范

要符合`Restful`规范。

数据操作归结为4类：`增删改查`。

`$resource`要做的事情也分为4类：`POST, DELETE, PUT, GET`

一般情况下，`PUT`会以`POST`代替。

网络请求中，最常用的是`POST`和`GET`。

我们在`Controller`内部编写`$resource`变量的时候，从此遵循以下的规范。

**$resource操作规范**

* 所有`$resource`变量都放在`$scope.resource`之下，也就是作为`$scope.resource`对象的元素。
* 变量命名：
  * `$resource`变量以名词命名，如果我需要请求一个跟所有`problem`相关的资源。那么我应该命名为：`all-problems`，然后这个变量主要用的方法可能是`GET`方法
  * 再比如，我要请求一个跟单个`problem`有关的资源。那么我应该命名为：`one-problem`，然后如果我要取得一个`problem`的信息，我就使用`GET`方法：`$scope.resource.one-problem.get`，如果我要添加或修改跟一个`problem`的信息，那么我就使用`save`方法：`$scope.resource.one-problem.save`，`save`方法在调用的时候要传递`method`参数来表示，是`post`类型接口，还是`put`类型接口。最后删除就对应`$scope.resource.one-problem.delete`了。
* `$resource`变量定义时的第一个参数是`url`，`url`的命名跟`$resource`保持一致，为了不混乱，这个很重要。这里的`url`跟express代码的`url`保持一致。参考 *8.1路由编写规范*
* 所有网络请求操作都用函数进行封装
  * 函数命名规范参考：*6 LiveScript开发规范:6.1 LiveScript变量，函数命名规范*

## 5.2 app-angular文件目录规范

`app-angular`的文件目录按照功能模块进行划分。

下面的子目录理论上有：

```bash
/config: 配置文件
/controllers: 控制器文件
/stylesheets: 样式文件
/views: 视图文件
/directives: 指令文件
/services: 服务文件
/filters: 过滤器文件
/tests: 测试文件
*.client.module.ls: 模块声明文件
```

常用的有：`controllers`，`stylesheets`，`views`

下阶段，我们会重点关注测试。也就是`tests`文件夹的内容，保证我们写出来的代码的质量和正确性。

## 6 测试

### 6.1 UI自动化测试

web-driver：待补充...

### 6.2 JS代码单元测试

Karma：待补充...

## 7 部署

待补充...

## 8 附录

**Controller内部规范性代码分布**

```livescript

# ====== 1 $scope变量初始化 ======
init-scope-variable = !->

# ====== 2 $rootScope变量初始化 ======
init-rootScope-variable = !->

# ====== 3 $resource变量初始化 ======
init-resource-variable = !->

# ====== 4 页面元素初始化 ======
init-page-dom = !->

# ====== 5 页面数据初始化 ======
init-page-data = !->

# ====== 6 controller初始化接口 ======
init-* = !->
  init-scope-variable!
  init-rootScope-variable!
  init-resource-variable!

  init-page-data!
  init-page-dom!

# ====== 7 $scope事件函数定义 ======

# ====== 8 工具函数定义 ======

# ====== 9 数据访问函数 ======

# ====== 10 初始化函数执行 ======
init-*!

```

