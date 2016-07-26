angular.module 'ManageLogin' .controller 'manage-login', ['$scope', '$resource', '$timeout', '$loginSM', '$braecoConsole', 'md5', '$http', ($scope, $resource, $timeout, $loginSM, $braecoConsole, md5, $http)!->

  # ====== 1 $scope变量初始化 ======
  init-scope-variable = !->
    $scope.form =
      username: null
      password: null
      is-record-username: null
      is-submit-disabled: false

  # ====== 2 $rootScope变量初始化 ======
  init-rootScope-variable = !->

  # ====== 3 $resource变量初始化 ======
  init-resource-variable = !->
    $scope.resource = {}
    $scope.resource.one-user = $resource '/dinner/login'

  # ====== 4 页面元素初始化 ======
  init-page-dom = !->
    init-recorded-username!

  # ====== 5 页面数据初始化 ======
  init-page-data = !->
    # access-the-status-code!

  # ====== 6 controller初始化接口 ======
  init-manage-login = !->
    init-scope-variable!
    init-rootScope-variable!
    init-resource-variable!

    init-page-data!
    init-page-dom!

  # ====== 7 $scope事件函数定义 ======
  $scope.forgot-password = (event)!->
    alert '忘记密码功能还没有实现哦', true

  $scope.register-one-user = (event)!->
    alert '注册功能还没开放哦', true

  $scope.record-the-username = (event)!->
    if $scope.form.is-record-username is true
      localStorage.set-item 'braeco-manage-username', $scope.form.username
    else
      localStorage.set-item 'braeco-manage-username', ''

  $scope.login-one-user = (event)!->
    if $scope.form.is-submit-disabled is false
      username = $scope.form.username
      password = md5.create-hash $scope.form.password

      # http://www.cnblogs.com/jihua/archive/2012/09/28/yanzheng.html
      if /^1\d{10}$/.test(username) is true or /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/.test(username) is true
        retrieve-one-user username, password
      else 
        alert '用户名格式必须是手机号码或者邮箱'

    else
      alert '提交正在进行，请稍后', false

    event.prevent-default!

  # ====== 8 工具函数定义 ======
  init-recorded-username = !->
    if localStorage.get-item('braeco-manage-username') is ''
      $scope.form.username = ''
      $scope.form.is-record-username = false
    else
      $scope.form.username = localStorage.get-item 'braeco-manage-username'
      $scope.form.is-record-username = true

  set-on-submit-state = !->
    $ 'input[type="submit"]' .add-class 'disabled'
    $scope.form.is-submit-disabled = true

  set-after-submit-state = !->
    $ 'input[type="submit"]' .remove-class 'disabled'
    $scope.form.is-submit-disabled = false

  # ====== 9 数据访问函数 ======
  retrieve-one-user = (username, password)!->
    set-on-submit-state!

    post-data =
      username: username
      password: password

    callback = (result)!->
      $braecoConsole result
      switch result.message
      | 'Wrong password'   => alert '密码错误'
      | 'User not found'   => alert '用户不存在'
      | 'Dinner not found' => alert '用户不是店长或店员'
      | 'success'          => location.href = '/Manage/Menu/Category'; return;

      set-after-submit-state!

    result = $scope.resource.one-user.save {}, post-data, !->
      callback result

  access-the-status-code = !->
    success-func = (response)!->
      if response.status is 200
        $braecoConsole response
        # location.href = '/Manage/Menu/Category'

    error-func = (response)!->
      $braecoConsole response.status

    $http { method: 'POST', url: '/Activity/Get' } .then success-func, error-func

  # ====== 10 初始化函数执行 ======
  init-manage-login!

]
