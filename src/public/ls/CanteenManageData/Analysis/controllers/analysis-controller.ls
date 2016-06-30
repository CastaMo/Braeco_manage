# =============== 控制器 ================
angular.module 'ManageDataAnalysis' .controller 'data-analysis', ['$scope', '$resource', '$timeout', '$analysisSM', ($scope, $resource, $timeout, $analysisSM)!->

  # ====== 1 $scope变量初始化 ======
  init-scope-variable = !->
    $scope.selected-tab = "member" # tab类型：member, coupons

    $scope.filter =
      # 会员发展tab
      member-time-type: 'day' # 网络请求参数
      member-selected-date: null # 网络请求参数
      member-selected-month: null # 网络请求参数
      member-selected-year: null # 网络请求参数

      # 卡券核销tab
      coupons-time-type: 'day' # 网络请求参数
      coupons-selected-date: null # 网络请求参数
      coupons-selected-month: null # 网络请求参数
      coupons-selected-year: null # 网络请求参数
      coupons-selected-coupon-type: 1 # 本地筛选参数
      coupons-selected-batc-number: 1 # 本地筛选参数

      # 餐厅所有月份、年份
      all-months: []
      all-years: []

    # 图表实例
    $scope.analysis-member-chart = null
    $scope.analysis-coupons-chart = null

    $scope.statistic = null

    $scope.member =
      # all-members: 0
      new-members: 0
      return-customers: 0

      member-classes: []

      membership-charge: 0
      membership-spend: 0

    $scope.selected-panel = 'current-members'

  # ====== 2 $rootScope变量初始化 ======
  init-rootScope-variable = !->

  # ====== 3 $resource变量初始化 ======
  init-resource-variable = !->
    $scope.resource = {}
    $scope.resource.statistics = $resource '/Dinner/Manage/Statistic'
    $scope.resource.coupons = $resource '/Dinner/Manage/Statistic/Coupon'

  # ====== 4 页面元素初始化 ======
  init-page-dom = !->
    init-side-menu!
    init-datepicker-defaults!
    init-datepicker!
    init-date-inputs!

  # ====== 5 页面数据初始化 ======
  init-page-data = !->
    $scope.get-statistics-by-unit!

  # ====== 6 $scope事件函数定义 ======
  $scope.get-statistics-by-unit = !->
    debugger

    time-type = if $scope.selected-tab == 'member' then $scope.filter.member-time-type else $scope.filter.coupons-time-type
    callback = if $scope.selected-tab == 'member' then get-retrieve-member-data-callback! else get-retrieve-coupons-data-callback!

    switch time-type
    | 'day'     => retrieve-statistics-or-coupons 'day', get-selected-date-object-from-date-and-week-type!, callback
    | 'week'    => retrieve-statistics-or-coupons 'week', get-selected-date-object-from-date-and-week-type!, callback
    | 'month'   => retrieve-statistics-or-coupons 'month', get-date-object-from-zh-cn-string($scope.statistics-filter.selected-month), callback
    | 'year'    => retrieve-statistics-or-coupons 'year', get-date-object-from-zh-cn-string($scope.statistics-filter.selected-year), callback
    | otherwise => throw new Error('time-type is invalid!')

  $scope.set-selected-tab = (event, tab)!->
    $ '.analysis-main-tabs .tab' .remove-class 'choose'
    $ event.current-target .add-class 'choose'
    $scope.selected-tab = tab

  $scope.set-selected-panel = (event, type)!->
    switch type
    | 'current-members' => set-selected-panel event.current-target, '112px', type
    | 'member-class'    => set-selected-panel event.current-target, '345px', type
    | 'current-balance' => set-selected-panel event.current-target, '580px', type

  # ====== 7 controller初始化接口 ======
  init-data-statistics = !->
    init-scope-variable!
    init-rootScope-variable!
    init-resource-variable!

    init-page-dom!
    init-page-data!

  # ====== 8 工具函数定义 ======
  init-chart = !->
    if $scope.selected-tab is 'member'
      if $scope.selected-panel is 'current-members' or $scope.selected-panel is 'current-balanc'
        init-line-chart!
      else if $scope.selected-panel is 'member-class'
        init-pie-chart!
    else if $scope.selected-tab is 'coupons'
      init-line-chart!

  init-line-chart = !->
    set-line-chart-global-defaults!
    options = get-line-chart-options!
    data = get-line-chart-data!
    ctx = get-line-chart-canvas!
    destroy-current-chart!

    line-chart-option =
      type: 'line'
      data: data
      options: options

    $scope.analysis-chart = new Chart ctx, line-chart-option

  init-pie-chart = !->
    set-pie-chart-global-defaults!
    options = get-pie-chart-options!
    data = get-pie-chart-data!
    ctx = document.getElementById "statistics-pie-chart"

    pie-chart-option =
      type: 'pie'
      data: data
      options: options

    $ '\#statistics-line-chart' .css 'display', 'none'
    $ '\#statistics-pie-chart' .css 'display', ''

    if $scope.statistic-chart isnt null
      $scope.statistic-chart.destroy!
      $scope.statistic-chart = null

    $scope.analysis-chart = new Chart ctx, pie-chart-option

  init-side-menu = !->
    $ "\#Market-Analysis-sub-menu" .add-class "choose"

  init-datepicker-defaults = !->
    options =
      autohide: true

    $.fn.datepicker.setDefaults options

  init-datepicker = !->
    $ '[data-toggle="datepicker"]' .datepicker {language: 'zh-CN', start-view: 0}

  set-line-chart-global-defaults = !->
    Chart.defaults.global.legend.position = 'bottom'
    Chart.defaults.global.hover.mode = 'dataset'
    Chart.defaults.global.tooltips.enabled = true
    Chart.defaults.global.tooltips.mode = 'label'
    Chart.defaults.global.legend.labels.boxWidth = 15

  set-pie-chart-global-defaults = !->

  set-selected-panel = (target, left, type)!->
    $ '.data-panel-item' .remove-class 'choose'
    $ target .add-class 'choose'
    $ '.triangle' .css 'left', left

    $scope.selected-panel = type

  init-date-inputs = !->
    $ 'input[data-toggle="datepicker"]' .datepicker 'setDate', new Date
    value = $ '.time-type-datepicker' .val!
    $scope.filter.member-date = value
    $scope.filter.coupons-date = value

  init-all-years-and-all-months = !->
    if $scope.register-time is null or $scope.register-time is undefined
      throw new Error('$scope.register-time is null or undefined')

    register-time-date-obj = get-date-object $scope.register-time
    now-date-obj = get-date-object(new Date)

    set-all-years register-time-date-obj, now-date-obj
    set-all-months register-time-date-obj, now-date-obj
    # set-selected-month-and-year!

  set-all-years = (register-time-date-obj, now-date-obj)!->
    all-years = []
    for i from register-time-date-obj.year to now-date-obj.year
      year = i + '年'
      all-years.push year
    $scope.filter.all-years = all-years

  set-all-months = (register-time-date-obj, now-date-obj)!->
    all-months = []
    total-months-obj = get-total-months-obj register-time-date-obj, now-date-obj
    base-year = register-time-date-obj.year
    base-month = register-time-date-obj.month

    # 注册年份的月份数
    for i from 0 to total-months-obj.register-year-month-gap
      month = base-year + '年' + (base-month + i) + '月'
      all-months.push month

    base-year++

    # 中间相隔的年数的月份数
    for i from 0 to total-months-obj.year-gap - 1
      for j from 1 to 12
        month = (base-year + i) + '年' + j + '月'
        all-months.push month

    base-year = base-year + total-months-obj.year-gap

    # 今年的月份数
    for i from 0 to total-months-obj.now-year-month-gap - 1
      month = base-year + '年' + (i + 1) + '月'
      all-months.push month

    $scope.filter.all-months = all-months

  set-waiting-state = !->
    $timeout !->
      $analysisSM.go-to-state ['\#analysis-main', '\#analysis-spinner']
    , 0

  set-ready-state = !->
    $timeout !->
      $analysisSM.go-to-state ['\#analysis-main']
    , 0

  set-datepicker-start-and-end-date = !->
    $scope.datepicker.date-begin.datepicker 'setStartDate', $scope.register-time
    $scope.datepicker.date-begin.datepicker 'setEndDate', new Date

  set-current-members-data-panel = !->
    $scope.member.new-members = $scope.statistic.new_member
    $scope.member.return-customers = $scope.statistic.returning_customer

  set-member-class-data-panel = !->
    $scope.member.member-classes = [1, 2, 3, 4, 5, 6]

  set-current-balance-data-panel = !->
    $scope.member.membership-charge = $scope.statistic.membership_charge
    $scope.member.membership-spend = $scope.statistic.membership_spend

  destroy-current-chart = !->
    if $scope.selected-tab is 'member'
      if $scope.analysis-member-graph
        $scope.analysis-member-graph.destroy!
        $scope.analysis-member-graph = null
    else if $scope.selected-tab is 'coupons'
      if $scope.analysis-coupons-graph
        $scope.analysis-coupons-graph.destroy!
        $scope.analysis-coupons-graph = null

  get-line-chart-options = ->
    scales:
      yAxes: [{
        ticks: {
          beginAtZero: true
        }
      }]

  get-line-chart-data = ->
    color-settings = get-line-chart-color-settings!
    data = get-line-chart-raw-data!
    legends = get-line-chart-legends!
    dataset-item = get-dataset-item!

    datasets = get-line-chart-datasets color-settings, data, legends, dataset-item

    labels = get-line-chart-labels!

    data =
      labels: labels
      datasets: datasets

  get-line-chart-canvas = ->
    canvas = null
    if $scope.selected-tab is 'member'
      canvas = document.getElementById 'analysis-member-graph'
    else if $scope.selected-tab is 'coupons'
      canvas = document.getElementById 'analysis-coupons-graph'
    canvas

  get-line-chart-color-settings = ->
    color-settings =
      backgroundColors: [
        'rgba(75, 192, 192, 0.4)',
        'rgba(33, 150, 243, 0.4)',
        'rgba(76, 175, 80, 0.4)',
        'rgba(139, 195, 74, 0.4)',
        'rgba(255, 235, 59, 0.4)',
        'rgba(121, 85, 72, 0.4)',
        'rgba(63, 81, 181, 0.4)',
        'rgba(233, 30, 99, 0.4)'
      ]

      borderColors: [
        'rgba(75, 192, 192, 1)',
        'rgba(33, 150, 243, 1)',
        'rgba(76, 175, 80, 1)',
        'rgba(139, 195, 74, 1)',
        'rgba(255, 235, 59, 1)',
        'rgba(121, 85, 72, 1)',
        'rgba(63, 81, 181, 1)',
        'rgba(233, 30, 99, 1)'

      ]

      pointHoverBackgroundColors: [
        'rgba(75, 192, 192, 1)',
        'rgba(33, 150, 243, 1)',
        'rgba(76, 175, 80, 1)',
        'rgba(139, 195, 74, 1)',
        'rgba(255, 235, 59, 1)',
        'rgba(121, 85, 72, 1)',
        'rgba(63, 81, 181, 1)',
        'rgba(233, 30, 99, 1)'
      ]

  get-line-chart-raw-data = ->
    current-data-box = $scope.current-data-box

    date-type = $scope.statistics-filter.date-type
    data-type = $scope.statistics-filter.data-type

    detail-data = get-detail-data current-data-box
    detail-data-types = get-detail-data-type!

    chart-data = get-chart-datasets-data date-type, detail-data-types, detail-data[data-type]

    chart-data

  get-member-number-line-chart-legends = ->
    ['新增会员数', '回头客数']

  get-current-balance-line-chart-legends = ->
    ['余额消费']

  get-coupons-market-line-chart-legends = ->
    ['浏览次数', '领取次数', '核销次数']

  get-dataset-item = ->

  get-line-chart-datasets = (color-settings, data, legends, dataset-item)->

  get-line-chart-labels = ->


  get-selected-date-object-from-date-and-week-type = ->
    date = null

    switch $scope.selected-tab
    | 'member'  => date = $ '.member-time-type-datepicker' .datepicker 'getDate'
    | 'coupons' => date = $ '.coupons-time-type-datepicker' .datepicker 'getDate'

    get-date-object date

  # {register-year-month-gap:, year-gap:, now-year-month-gap:}
  get-total-months-obj = (register-time-date-obj, now-date-obj)->
    obj = {}
    obj.year-gap = now-date-obj.year - register-time-date-obj.year - 1
    obj.register-year-month-gap = 12 - register-time-date-obj.month
    obj.now-year-month-gap = now-date-obj.month
    obj

  get-date-object = (date)->
    if date not instanceof Date
      throw new Error('The parameter "date" is not a instance of "Date"')

    obj = {}
    obj.year = date.get-full-year!
    obj.month = date.get-month! + 1 # 月份从0开始
    obj.day = date.get-date!
    obj

  get-retrieve-member-data-callback = ->
    retrieve-member-data-callback = (result)!->
      if !$scope.register-time
        $scope.register-time = new Date(result.register_time * 1000)
        init-all-years-and-all-months!
        # set-datepicker-start-and-end-date!

      $scope.statistic = result.statistic

      set-current-members-data-panel!
      set-member-class-data-panel!
      set-current-balance-data-panel!

      console.log '$scope.statistic: ', $scope.statistic

      init-chart!
      set-ready-state!

    retrieve-member-data-callback

  get-retrieve-coupons-data-callback = ->
    retrieve-coupons-data-callback = (result)!->

    retrieve-coupons-data-callback

  # ====== 9 数据访问函数 ======

  # CRUD之Retrieve，date-obj = {year:, month:, date:}
  retrieve-statistics-or-coupons = (type, date-obj, callback)!->
    set-waiting-state!

    post-data = {}
    post-data <<< date-obj

    switch type
    | 'year'    => post-data.unit = 'year'
    | 'month'   => post-data.unit = 'month'
    | 'week'    => post-data.unit = 'week'
    | 'day'     => post-data.unit = 'day'
    | otherwise => throw new Error('The parameter "type" is none of ["year", "month", "week", "day"]')

    resource = if $scope.selected-tab == 'member' then $scope.resource.statistics else $scope.resource.coupons

    result = resource.save {}, post-data, !->
      console.log 'function: retrieve-statistics-by-year, get initial statistics done!'
      callback? result

  # ====== 10 初始化函数执行 ======

  init-data-statistics!

]
