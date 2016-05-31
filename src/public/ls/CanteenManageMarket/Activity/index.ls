# 'use strict';

# let win = window
	# Activity = require './activity.js'
	# win.activity = new Activity

# 时间给的太紧，临时使用angular框架

# ========== 初始化 =========
ng-app = 'BraecoActivity'
ng-app-module = angular.module ng-app, ['ngResource']
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false;
]

# ========== 手动引导ng-app ===========
angular.element document .ready !->
  angular.bootstrap document, [ng-app]

# ============ 引入模块 =============
View = require './activityView.js'
Controller = require './activityController.js'

# =============== 控制器 ================
ng-app-module.controller 'category-main', ['$rootScope', '$scope', '$location', '$resource', ($rootScope, $scope, $location, $resource)->
  # ====== $rootScope定义变量 =======
  $rootScope.view = init-activity-view!
  $rootScope.controller = new Controller
  $rootScope.current-id = null

  # ======= $scope 定义变量 =======
  $scope.sales-activities = []
  $scope.theme-activities = []
  $scope.base-image-url = 'http://static.brae.co/images/activity/'
  $scope.activityName = ''
  $scope.expiryDate = ''
  $scope.activityStartDate
  $scope.activityEndDate
  $scope.activityUploadImage
  $scope.activityBrief = ''
  $scope.activityContent = ''
  $scope.is-addding-activity = false

  pre-image-url = 'http://ww4.sinaimg.cn/large/ed796d65gw1f4etfd2bn8j20e807l0tw.jpg'

  # ======= 初始化操作 ========
  init-activity-data $scope
  $rootScope.controller.page-init!
  $rootScope.controller.letter-number-limit-init!
  $rootScope.controller.date-range-init!

  # ====== scope函数定义 ========
  $scope.new-promotion-activity = (event)!->
    flag = true
    if $scope.is-addding-activity
      if confirm '舍弃正在编辑的活动？'
        flag = true
      else
        flag = false

    if flag
      $scope.sales-activities.push item =
        title: ''
        pic: ''
        intro: ''
        content: ''

      set-timeout !->
        $ '.reduce-activities-list' .animate {scrollTop: 9999}, 1000
      , 0

      $scope.activityName = ''
      $scope.expiryDate = 0
      # $scope.activityStartDate
      # $scope.activityEndDate
      # $scope.activityUploadImage
      $scope.activityBrief = ''
      $scope.activityContent = ''

  $scope.new-theme-activity = (event)!->
    $scope.theme-activities.push item =
      title: ''
      pic: ''
      intro: ''
      content: ''

    set-timeout !->
      $ '.theme-activities-list' .animate {scrollTop: 9999}, 1000
    , 0

  $scope.activity-item-click-event = (event)!->
    console.log @activity
    $scope.activityName = @activity.title

    if @activity.date_begin is '0' and @activity.date_end is '0'
      $scope.expiryDate = 0
    else
      $scope.expiryDate = 1
      $scope.activityStartDate = @activity.date_begin
      $scope.activityEndDate = @activity.date_end

    $ '#activity-image-preview' .attr 'src', $scope.base-image-url + @activity.pic

    $scope.activityBrief = @activity.intro
    $scope.activityContent = @activity.content

    $rootScope.current-id = @activity.id

    $ '.activity-name .letter-number' .text $rootScope.controller.get-total-num-length-of-cn-and-en-text(@activity.title) + ' / 10'
    $ '.activity-brief .letter-number' .text $rootScope.controller.get-total-num-length-of-cn-and-en-text(@activity.intro) + ' / 40'
    $ '.activity-content .letter-number' .text $rootScope.controller.get-total-num-length-of-cn-and-en-text(@activity.content) + ' / 200'

]


# 初始化活动数据
init-activity-data = (scope)!->
  activities-data = JSON.parse window.all-data
  activities-data.data.for-each (item)!->
    if item.type is 'theme'
      scope.theme-activities.push item
    else
      scope.sales-activities.push item

# 初始化view
init-activity-view = ->
  view = new View options =
    initial: ['\#category-main']
    views: ['\#category-main', '\#upload-canteen-image', '\#activity-spinner']
    transitions: [
      {
        from: ['\#category-main']
        to: ['\#category-main', '\#upload-canteen-image']
        on: ['.upload-canteen-photo click']
      },
      {
        from: ['\#category-main', '\#upload-canteen-image']
        to: ['\#category-main']
        on: ['.upload-canteen-image-mask click', '.upload-canteen-image-close click', '\#canteen-image-cancel click']
      }
    ]
    show-state: ['activity-fade-in']
    hide-state: ['activity-fade-out']
    init-state: ['activity-init']
  view
