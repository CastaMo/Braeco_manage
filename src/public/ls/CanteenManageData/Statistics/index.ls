# ========== 初始化 =========
ng-app = 'ManageDataStatistics'
ng-app-module = angular.module ng-app, ['ngResource']
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false
]

# ====== angular 过滤器定义 ======

# 数据过滤器
ng-app-module.filter 'datafilter', ->

  datafilter = (data)->
    if data is undefined or data is null
      return 0
    else return data

  datafilter

# ========== 加载外部模块 ===========
statistics-init = require './statisticsInit.js'

# ========== 手动引导ng-app ===========
angular.element document .ready !->
  angular.bootstrap document, [ng-app]

# =============== 控制器 ================
ng-app-module.controller 'data-statistics', ['$scope', '$resource', '$timeout', ($scope, $resource, $timeout)!->

  # ====== 1 $scope变量初始化 ======
  init-scope-variable = !->
    $scope.view = statistics-init.get-statistics-view! # 页面状态机控制

    $scope.register-time = null # 餐厅注册时间，数据初始化的时候设置一次即可
    $scope.statistic = {} # 请求到来的数据，每一次数据请求都要设置

    $scope.statistics-filter =
      date-type: 'day' # unit的单位
      all-years: null # 餐厅自注册以来的年份数组
      all-months: null # 餐厅自注册以来的月份数组
      data-type: 'all' # 筛选的数据类型
      date-begin: null # week和day的开始时间
      selected-month: null # 当unit为month时，是选中的month
      selected-year: null # 当unit为year时，是选中的year

    $scope.turnover =
      all: null
      cash: null
      p2p_wx_pub: null
      wx_pub: null
      alipay_wap: null
      alipay_qr_f2f: null
      bfb_wap: null
      prepayment: null

    $scope.orders =
      all: null
      cash: null
      p2p_wx_pub: null
      wx_pub: null
      alipay_wap: null
      alipay_qr_f2f: null
      bfb_wap: null
      prepayment: null

    $scope.current-data-box = 'turnover'

    $scope.datepicker = {}
    $scope.datepicker.date-begin = null # unit单位为week或day时的时间值

    $scope.chart = {}
    $scope.chart.options = null
    $scope.chart.data = null

    $scope.statistic-chart = null

  # ====== 2 $rootScope变量初始化 ======
  init-rootScope-variable = !->

  # ====== 3 $resource变量初始化 ======
  init-resource-variable = !->
    $scope.resource = {}
    $scope.resource.statistics = $resource '/Dinner/Manage/Statistic'

  # ====== 4 页面元素初始化 ======
  init-page-dom = !->
    init-side-menu!
    init-datepicker-defaults!
    init-datepicker!
    init-date-inputs!

  # ====== 5 页面数据初始化 ======
  init-page-data = !->

  # ====== 6 $scope事件函数定义 ======
  $scope.get-statistics-by-unit = !->

    set-waiting-state!

    callback = (result)!->
      if $scope.register-time is null
        $scope.register-time = new Date(result.register_time * 1000)
        init-all-years-and-all-month!
        set-datepicker-start-and-end-date!

      $scope.statistic = result.statistic
      set-turnover-data!
      set-orders-data!

      console.log $scope.statistic
      init-line-chart!
      set-ready-state!

    switch $scope.statistics-filter.date-type
    | 'day'     => retrieve-statistics 'day', get-select-date-object-from-date-and-week-type!, callback
    | 'week'    => retrieve-statistics 'week', get-select-date-object-from-date-and-week-type!, callback
    | 'month'   => retrieve-statistics 'month', get-date-object-from-zh-cn-string($scope.statistics-filter.selected-month), callback
    | 'year'    => retrieve-statistics 'year', get-date-object-from-zh-cn-string($scope.statistics-filter.selected-year), callback
    | otherwise => throw new Error('$scope.statistics-filter.date-type is invalid!')

  $scope.select-statistics-type = (event, type)!->
    $ '.data-box' .remove-class 'choose'
    $ event.current-target .add-class 'choose'
    $scope.current-data-box = type

    left = 0
    switch type
    | 'turnover'     => left = '108px'
    | 'orders'       => left = '345px'
    | 'sales-volume' => left = '580px'

    $ '.graph-triangle' .css 'left', left

    init-line-chart!

  $scope.printSmallTicket = (event)!->
    alert '打印日结小票功能还没实现哦'

  $scope.set-data-by-data-type = (event)!->
    set-turnover-data!
    set-orders-data!
    init-line-chart!

  # ====== 7 controller初始化接口 ======
  init-data-statistics = !->
    init-scope-variable!
    init-rootScope-variable!
    init-resource-variable!

    init-page-dom!
    init-page-data!

  # ====== 8 工具函数定义 ======
  init-side-menu = !->
    $ "\#Data-sub-menu" .add-class "choose"

  init-datepicker-defaults = !->
    options =
      autohide: true

    $.fn.datepicker.setDefaults options

  init-datepicker = !->
    $ '[data-toggle="datepicker"]' .datepicker {language: 'zh-CN'}
    $scope.datepicker.date-begin = $ '.date-begin'

  init-date-inputs = !->
    $ '.date-range.date-begin' .on 'keydown', -> false

    # 500ms后能确保需要的DOM加载完毕
    $timeout !->
      $scope.datepicker.date-begin.datepicker 'setDate', new Date
    , 500

  init-line-chart = !->
    set-chart-global-defaults!
    options = get-chart-options!
    data = get-chart-data!
    ctx = document.getElementById "statistics-chart"

    chart-option =
      type: 'line'
      data: data
      options: options

    if $scope.statistic-chart isnt null
      $scope.statistic-chart.destroy!
      $scope.statistic-chart = null

    $scope.statistic-chart = new Chart ctx, chart-option

  init-all-years-and-all-month = !->
    if $scope.register-time is null
      throw new Error('$scope.register-time is null')

    register-time-date-obj = get-date-object $scope.register-time
    now-date-obj = get-date-object(new Date)

    set-scope-all-years register-time-date-obj, now-date-obj
    set-scope-all-months register-time-date-obj, now-date-obj
    set-selected-month-and-year!

  set-scope-all-years = (register-time-date-obj, now-date-obj)!->
    all-years = []
    for i from register-time-date-obj.year to now-date-obj.year
      year = i + '年'
      all-years.push year
    $scope.statistics-filter.all-years = all-years

  set-scope-all-months = (register-time-date-obj, now-date-obj)!->
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

    $scope.statistics-filter.all-months = all-months

  set-selected-month-and-year = !->
    $scope.statistics-filter.selected-month = $scope.statistics-filter.all-months[0]
    $scope.statistics-filter.selected-year = $scope.statistics-filter.all-years[0]

  set-datepicker-start-and-end-date = !->
    $scope.datepicker.date-begin.datepicker 'setStartDate', $scope.register-time
    $scope.datepicker.date-begin.datepicker 'setEndDate', new Date

  set-waiting-state = !->
    $timeout !->
      $scope.view.go-to-state ['\#statistics-main', '\#statistics-spinner-circle']
    , 0

  set-ready-state = !->
    $timeout !->
      $scope.view.go-to-state ['\#statistics-main']
    , 0

  set-turnover-data = !->
    type = $scope.statistics-filter.data-type

    switch type
    | 'all'        => set-scope-turnover $scope.statistic.amount_detail.all
    | 'eatin'      => set-scope-turnover $scope.statistic.amount_detail.eatin
    | 'takeout'    => set-scope-turnover $scope.statistic.amount_detail.takeout
    | 'takeaway'   => set-scope-turnover $scope.statistic.amount_detail.takeaway
    | 'membership' => set-scope-turnover $scope.statistic.amount_detail.membership

  set-scope-turnover = (turnover)!->
    $scope.turnover =
      all: turnover?.all?.amount
      cash: turnover?.cash?.amount
      p2p_wx_pub: turnover?.p2p_wx_pub?.amount
      wx_pub: turnover?.wx_pub?.amount
      alipay_wap: turnover?.alipay_wap?.amount
      alipay_qr_f2f: turnover?.alipay_qr_f2f?.amount
      bfb_wap: turnover?.bfb_wap?.amount
      prepayment: turnover?.prepayment?.amount

  set-orders-data = !->
    type = $scope.statistics-filter.data-type

    switch type
    | 'all'        => set-scope-orders $scope.statistic.sum_detail.all
    | 'eatin'      => set-scope-orders $scope.statistic.sum_detail.eatin
    | 'takeout'    => set-scope-orders $scope.statistic.sum_detail.takeout
    | 'takeaway'   => set-scope-orders $scope.statistic.sum_detail.takeaway
    | 'membership' => set-scope-orders $scope.statistic.sum_detail.membership

  set-scope-orders = (orders)!->
    $scope.orders =
      all: orders?.all?.sum
      cash: orders?.cash?.sum
      p2p_wx_pub: orders?.p2p_wx_pub?.sum
      wx_pub: orders?.wx_pub?.sum
      alipay_wap: orders?.alipay_wap?.sum
      alipay_qr_f2f: orders?.alipay_qr_f2f?.sum
      bfb_wap: orders?.bfb_wap?.sum
      prepayment: orders?.prepayment?.sum

  set-chart-global-defaults = !->
    Chart.defaults.global.legend.position = 'bottom'
    Chart.defaults.global.hover.mode = 'dataset'
    Chart.defaults.global.tooltips.enabled = true
    Chart.defaults.global.tooltips.mode = 'label'
    Chart.defaults.global.legend.labels.boxWidth = 15

  set-scope-chart-data = !->
    color-settings = get-line-chart-color-settings!
    data = get-line-chart-data!
    legends = get-line-chart-legends!
    dataset-item = get-dataset-item!

    datasets = get-line-chart-datasets color-settings, data, legends, dataset-item

    labels = get-line-chart-labels!

    $scope.chart.data =
      labels: labels
      datasets: datasets

  set-scope-chart-options = !->
    $scope.chart.options =
      scales:
        yAxes: [{
          ticks: {
            beginAtZero: true
          }
        }]

  # {register-year-month-gap:, year-gap:, now-year-month-gap:}
  get-total-months-obj = (register-time-date-obj, now-date-obj)->
    obj = {}
    obj.year-gap = now-date-obj.year - register-time-date-obj.year - 1
    obj.register-year-month-gap = 12 - register-time-date-obj.month
    obj.now-year-month-gap = now-date-obj.month
    obj

  # {year: , month: , day: }
  get-date-object = (date)->
    if date not instanceof Date
      throw new Error('The parameter "date" is not a instance of "Date"')

    obj = {}
    obj.year = date.get-full-year!
    obj.month = date.get-month! + 1 # 月份从0开始
    obj.day = date.get-date!
    obj

  # {year: [,month: ]}
  get-date-object-from-zh-cn-string = (str)->
    year = str.substring(0, str.indexOf('年'))
    month = null
    if str.indexOf('月') isnt -1
      month = str.substring(str.indexOf('年')+1, str.indexOf('月'))

    obj = {}; obj.year = parse-int year
    if month is not null then obj.month = parse-int month

    obj

  # return date-object({year: , month: , day: })
  get-select-date-object-from-date-and-week-type = ->
    get-date-object $scope.datepicker.date-begin.datepicker('getDate')

  get-chart-options = ->
    set-scope-chart-options!
    $scope.chart.options

  get-chart-data = ->
    set-scope-chart-data!
    $scope.chart.data

  get-dataset-item = ->
    dataset-item =
      label: 'label'
      data: []
      backgroundColor: 'rgba(75,192,192,0.4)'
      borderColor: 'rgba(75,192,192,1)'
      borderWidth: 1
      borderCapStyle: 'butt'
      borderDash: []
      borderDashOffset: 0.0
      borderJoinStyle: 'miter'

      pointBorderColor: "rgba(0,0,0,0.5)"
      pointBackgroundColor: "\#fff"
      pointBorderWidth: 1
      pointRadius: 5
      pointHitRadius: 10

      pointHoverRadius: 6
      pointHoverBackgroundColor: 'rgba(75,192,192,1)'
      pointHoverBorderColor: "rgba(220, 220, 220, 0.4)"
      pointHoverBorderWidth: 1

      hidden: true

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

  get-line-chart-data = ->
    current-data-box = $scope.current-data-box
    date-type = $scope.statistics-filter.date-type
    data-type = $scope.statistics-filter.data-type

    detail-data = get-detail-data current-data-box
    detail-data-types = get-detail-data-type!

    debugger
    chart-data = get-chart-datasets-data date-type, detail-data-types, detail-data[data-type]

    chart-data

  get-chart-datasets-data = (date-type, detail-data-types, detail-data)->
    chart-data = []

    detail-data-types.for-each (item)!->
      if detail-data[item] isnt undefined
        chart-data.push detail-data[item].detail
      else
        switch date-type
        | 'day'   => chart-data.push [i - i for i from 0 to 23]
        | 'week'  => chart-data.push [i - i for i from 0 to 6]
        | 'month' => chart-data.push [i - i for i from 0 to 29] # 临时
        | 'year'  => chart-data.push [i - i for i from 0 to 11]

    chart-data

  get-detail-data-type = ->
    ['all', 'cash', 'p2p_wx_pub', 'wx_pub', 'alipay_wap', 'alipay_qr_f2f', 'bfb_wap', 'prepayment']

  get-detail-data = (current-data-box)->
    detail-data = null

    switch current-data-box
    | 'turnover'     => detail-data = $scope.statistic.amount_detail
    | 'orders'       => detail-data = $scope.statistic.sum_detail

    detail-data

  get-line-chart-legends = ->
    legend = ['所有', '现金', '微信P2P', '微信代收', '支付宝网页付', '支付宝扫码', '百度钱包', '会员余额']

  get-line-chart-labels = ->
    type = $scope.statistics-filter.date-type
    labels = null

    switch type
    | 'day'   => labels = get-day-labels!
    | 'week'  => labels = get-week-labels!
    | 'month' => labels = get-month-labels!
    | 'year'  => labels = get-year-labels!

    labels

  get-day-labels = ->
    length = 24
    labels = []

    for i from 1 to 24
      item = i + '时'
      labels.push item

    labels

  get-week-labels = ->
    date-object = get-select-date-object-from-date-and-week-type!
    days-of-month = get-days-number-of-month date-object.year, date-object.month

    week-labels = []
    month = date-object.month
    day = date-object.day

    for i from 0 to 6
      if day > days-of-month
        day = 1
        month++

        if month > 12
          month = 1
      item = month + '月' + day + '日'
      week-labels.push item
      day++

    week-labels

  get-month-labels = ->
    date-object = get-date-object-from-zh-cn-string $scope.statistics-filter.selected-month
    day-number = get-days-number-of-month date-object.year, date-object.month

    [i + '日' for i from 1 to day-number]

  get-days-number-of-month = (year, month)->
    new Date(year, month, 0).getDate!

  get-year-labels = ->
    ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]

  get-line-chart-datasets  = (color-settings, data, legends, dataset-item)->
    datasets = []
    length = 7

    for i from 0 to length
      dataset-item.backgroundColor = color-settings.backgroundColors[i]
      dataset-item.borderColor = color-settings.borderColors[i]
      dataset-item.pointHoverBackgroundColor = color-settings.pointHoverBackgroundColors[i]
      dataset-item.data = data[i]
      dataset-item.label = legends[i]

      temp = JSON.parse JSON.stringify(dataset-item) # trick deep clone
      if i is 0 then temp.hidden = false

      datasets.push temp

    datasets

  # ====== 9 数据访问函数 ======

  # CRUD之Retrieve，date-obj = {year:, month:, date:}
  retrieve-statistics = (type, date-obj, callback)!->

    post-data = {}
    post-data <<< date-obj

    switch type
    | 'year'    => post-data.unit = 'year'
    | 'month'   => post-data.unit = 'month'
    | 'week'    => post-data.unit = 'week'
    | 'day'     => post-data.unit = 'day'
    | otherwise => throw new Error('The parameter "type" is none of ["year", "month", "week", "day"]')

    result = $scope.resource.statistics.save {}, post-data, !->
      console.log 'function: retrieve-statistics-by-year, get initial statistics done!'
      callback? result

  # ====== 10 初始化函数执行 ======

  init-data-statistics!

]
