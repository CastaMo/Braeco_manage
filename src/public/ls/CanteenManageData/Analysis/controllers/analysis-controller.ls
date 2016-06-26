# =============== 控制器 ================
angular.module 'ManageDataAnalysis' .controller 'data-analysis', ['$scope', '$resource', '$timeout', '$analysisSM', ($scope, $resource, $timeout, $analysisSM)!->

  # ====== 1 $scope变量初始化 ======
  init-scope-variable = !->
    $scope.selected-tab = "member"

  # ====== 2 $rootScope变量初始化 ======
  init-rootScope-variable = !->

  # ====== 3 $resource变量初始化 ======
  init-resource-variable = !->
    $scope.resource = {}

  # ====== 4 页面元素初始化 ======
  init-page-dom = !->
    init-datepicker-defaults!
    init-datepicker!

  # ====== 5 页面数据初始化 ======
  init-page-data = !->
    init-side-menu!

  # ====== 6 $scope事件函数定义 ======

  # ====== 7 controller初始化接口 ======
  init-data-statistics = !->
    init-scope-variable!
    init-rootScope-variable!
    init-resource-variable!

    init-page-dom!
    init-page-data!

  # ====== 8 工具函数定义 ======
  init-side-menu = !->
    $ "\#Market-Analysis-sub-menu" .add-class "choose"

  $scope.set-selected-tab = (event, tab)!->
    $ '.analysis-main-tabs .tab' .remove-class 'choose'
    $ event.current-target .add-class 'choose'
    $scope.selected-tab = tab

  init-datepicker-defaults = !->
    options =
      autohide: true

    $.fn.datepicker.setDefaults options

  init-datepicker = !->
    $ '[data-toggle="datepicker"]' .datepicker {language: 'zh-CN', start-view: 0}


  # ====== 9 数据访问函数 ======

  # ====== 10 初始化函数执行 ======

  init-data-statistics!

]
