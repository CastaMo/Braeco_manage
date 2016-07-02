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
      coupons-selected-coupon-type: '0' # 本地筛选参数
      coupons-selected-batch-number: null # 本地筛选参数

      # 餐厅所有月份、年份
      all-months: []
      all-years: []
      coupons-batch-number: []

    # 会员相关数据
    $scope.member =
      new-members: null
      old-members: null
      member-classes: null
      membership-charge: null
      membership-spend: null

    # 图表实例
    $scope.analysis-member-chart = null
    $scope.analysis-coupons-chart = null

    $scope.membership = null # 会员数据，记录时间变化
    $scope.coupons = null # 卡券数据，记录时间变化
    $scope.member-class = null # 会员等级数据，不记录时间变化
    $scope.sum-balance = null # 会员余额数据，不记录时间变化
    $scope.member-count = null # 会员总数，不记录时间变化

    $scope.selected-panel = 'current-members'
    $scope.now-time = null

  # ====== 2 $rootScope变量初始化 ======
  init-rootScope-variable = !->

  # ====== 3 $resource变量初始化 ======
  init-resource-variable = !->
    $scope.resource = {}
    $scope.resource.statistic = $resource '/Dinner/Manage/Statistic'
    $scope.resource.analysis = $resource '/Manage/Data/Analysis/JSON'

  # ====== 4 页面元素初始化 ======
  init-page-dom = !->
    init-side-menu!
    init-datepicker-defaults!
    init-datepicker!
    init-date-inputs!

  # ====== 5 页面数据初始化 ======
  init-page-data = !->
    retrieve-member-class-and-sumbalance!
    retrieve-statistics-by-type get-current-unit!, get-current-type!, get-current-date-obj!, get-current-callback-by-type!

  # ====== 6 $scope事件函数定义 ======
  $scope.select-batch-number = (event)!->
    console.log 'here is select-batch-number'
    init-chart!

  $scope.get-statistics-by-type = !->
    retrieve-statistics-by-type get-current-unit!, get-current-type!, get-current-date-obj!, get-current-callback-by-type!

  $scope.set-selected-tab = (event, tab)!->
    $ '.analysis-main-tabs .tab' .remove-class 'choose'
    $ event.current-target .add-class 'choose'
    $scope.selected-tab = tab

    if (tab is 'member' and !$scope.statistic) or (tab is 'coupons' and !$scope.coupons)
      retrieve-statistics-by-type get-current-unit!, get-current-type!, get-current-date-obj!, get-current-callback-by-type!

  $scope.set-selected-panel = (event, type)!->
    switch type
    | 'current-members' => set-selected-panel event.current-target, '112px', type
    | 'member-class'    => set-selected-panel event.current-target, '345px', type
    | 'current-balance' => set-selected-panel event.current-target, '580px', type

  # ====== 7 controller初始化接口 ======
  init-data-statistic = !->
    init-scope-variable!
    init-rootScope-variable!
    init-resource-variable!

    init-page-dom!
    init-page-data!

  # ====== 8 工具函数定义 ======
  init-chart = !->
    if $scope.selected-tab is 'member' and $scope.selected-panel is 'member-class'
      console.log 'init member-class pie chart'
      init-pie-chart!
    else if $scope.selected-tab is 'member' and $scope.selected-panel is 'current-members'
      console.log 'init current-members line chart'
      init-line-chart!
    else if $scope.selected-tab is 'member' and $scope.selected-panel is 'current-balance'
      console.log 'init current-balance line chart'
      init-line-chart!
    else if $scope.selected-tab is 'coupons'
      console.log 'init coupons line chart'
      init-line-chart!

  init-line-chart = (type)!->
    debugger
    set-line-chart-global-defaults!
    options = get-line-chart-options!
    data = get-line-chart-data!
    ctx = get-line-chart-canvas!

    destroy-current-chart!

    line-chart-option =
      type: 'line'
      data: data
      options: options
    debugger
    if $scope.selected-tab is 'member'
      $scope.analysis-member-chart = new Chart ctx, line-chart-option
    else
      $scope.analysis-coupons-chart = new Chart ctx, line-chart-option

  init-pie-chart = !->
    set-pie-chart-global-defaults!
    options = get-pie-chart-options!
    data = get-pie-chart-data!
    ctx = document.getElementById "analysis-member-graph"

    destroy-current-chart!

    pie-chart-option =
      type: 'pie'
      data: data
      options: options

    $scope.analysis-member-chart = new Chart ctx, pie-chart-option

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
    Chart.defaults.global.legend.position = 'bottom'
    Chart.defaults.global.hover.mode = 'dataset'
    Chart.defaults.global.tooltips.enabled = true
    Chart.defaults.global.tooltips.mode = 'label'
    Chart.defaults.global.legend.labels.boxWidth = 15

  set-selected-panel = (target, left, type)!->
    $ '.data-panel-item' .remove-class 'choose'
    $ target .add-class 'choose'
    $ '.triangle' .css 'left', left

    $scope.selected-panel = type
    console.log 'here is set-selected-panel'
    init-chart!

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
    set-selected-month-and-year!

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

  set-selected-month-and-year = !->
    $scope.filter.member-selected-month = $scope.filter.all-months[0]
    $scope.filter.coupons-selected-month = $scope.filter.all-months[0]
    $scope.filter.member-selected-year = $scope.filter.all-years[0]
    $scope.filter.coupons-selected-year = $scope.filter.all-years[0]

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
    $scope.member.old-members = $scope.statistic.old_member

  set-member-class-data-panel = !->
    $scope.member.member-classes = [1, 2, 3, 4, 5, 6]

  set-current-balance-data-panel = !->
    $scope.member.membership-charge = $scope.statistic.membership_charge
    $scope.member.membership-spend = $scope.statistic.membership_spend

  set-batch-numbers-array = !->
    $scope.filter.coupons-batch-number = Object.keys($scope.coupons.coupon_detail)
    $scope.filter.coupons-selected-batch-number = $scope.filter.coupons-batch-number[0]

  destroy-current-chart = !->
    if $scope.selected-tab is 'member'
      if $scope.analysis-member-chart
        $scope.analysis-member-chart.destroy!
        $scope.analysis-member-chart = null
    else if $scope.selected-tab is 'coupons'
      if $scope.analysis-coupons-chart
        $scope.analysis-coupons-chart.destroy!
        $scope.analysis-coupons-chart = null

  get-pie-chart-options = ->
    {}

  get-pie-chart-data = ->
    labels = get-pie-chart-data-labels!
    datasets = get-pie-chart-data-datasets!
    data =
      labels: labels
      datasets: datasets

  get-pie-chart-data-labels = ->
    ['Lv.0', 'Lv.1', 'Lv.2', 'Lv.3', 'Lv.4', 'Lv.5']

  get-pie-chart-data-datasets = ->
    backgroundColor = get-pie-chart-data-datasets-backgroundColor-and-hoverBackgroundColor!
    dataset-item =
      data: get-pie-chart-data-datasets-data!
      backgroundColor: backgroundColor
      hoverBackgroundColor: backgroundColor

    datasets = []
    datasets.push dataset-item
    datasets

  get-pie-chart-data-datasets-backgroundColor-and-hoverBackgroundColor = ->
    colors = []
    for i from 1 to 6
      colors.push get-rand-color(4)
    colors

  get-pie-chart-data-datasets-data = ->
    $scope.member-class

  # http://stackoverflow.com/a/7352887
  get-rand-color = (brightness)->
    # 6 levels of brightness from 0 to 5, 0 being the darkest
    rgb = [Math.random() * 256, Math.random() * 256, Math.random() * 256]
    mix = [brightness*51, brightness*51, brightness*51]; # 51 => 255/5
    mixedrgb = [rgb[0] + mix[0], rgb[1] + mix[1], rgb[2] + mix[2]].map (x)-> Math.round(x/2.0)

    "rgb(" + mixedrgb.join(",") + ")"

  get-current-unit = ->
    if $scope.selected-tab is 'member'
      return $scope.filter.member-time-type
    else if $scope.selected-tab is 'coupons'
      return $scope.filter.coupons-time-type

  get-current-type = ->
    if $scope.selected-tab is 'member'
      return 'membership'
    else if $scope.selected-tab is 'coupons'
      return 'coupon'

  get-current-date-obj = ->
    date-obj = null
    current-unit = get-current-unit!

    if $scope.selected-tab is 'member'
      switch current-unit
      | 'day', 'week' => date-obj = get-selected-date-object-from-date-and-week-type!
      | 'month'       => date-obj = get-date-object-from-zh-cn-string $scope.filter.member-selected-month
      | 'year'        => date-obj = get-date-object-from-zh-cn-string $scope.filter.member-selected-year
    else if $scope.selected-tab is 'coupons'
      switch current-unit
      | 'day', 'week' => date-obj = get-selected-date-object-from-date-and-week-type!
      | 'month'       => date-obj = get-date-object-from-zh-cn-string $scope.filter.coupons-selected-month
      | 'year'       => date-obj = get-date-object-from-zh-cn-string $scope.filter.coupons-selected-year

    date-obj

  get-current-callback-by-type = ->
    callback = null
    switch $scope.selected-tab
    | 'member'  => callback = get-retrieve-member-data-callback!
    | 'coupons' => callback = get-retrieve-coupons-data-callback!
    callback

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
    chart-data = []
    if $scope.selected-tab is 'member' and $scope.selected-panel is 'current-members'
      console.log 'init current-members line chart'
      chart-data.push $scope.statistic.new_membership_detail
      chart-data.push $scope.statistic.old_membership_detail
    else if $scope.selected-tab is 'member' and $scope.selected-panel is 'current-balance'
      console.log 'init current-balance line chart'
      chart-data.push $scope.statistic.membership_charge_detail
      chart-data.push $scope.statistic.membership_spend_detail
    else if $scope.selected-tab is 'coupons'
      console.log 'init coupons line chart'
      if $scope.coupons.coupon_sum isnt 0
        chart-data.push $scope.coupons.coupon_detail[$scope.filter.coupons-selected-batch-number].scan.detail
        chart-data.push $scope.coupons.coupon_detail[$scope.filter.coupons-selected-batch-number].get.detail
        chart-data.push $scope.coupons.coupon_detail[$scope.filter.coupons-selected-batch-number].get.detail
    chart-data

  get-line-chart-legends = ->
    debugger
    if $scope.selected-tab is 'member' and $scope.selected-panel is 'current-members'
      return get-member-number-line-chart-legends!
    else if $scope.selected-tab is 'member' and $scope.selected-panel is 'current-balance'
      return get-current-balance-line-chart-legends!
    else if $scope.selected-tab is 'coupons'
      return get-coupons-market-line-chart-legends!

  get-member-number-line-chart-legends = ->
    ['新增会员数', '回头客数']

  get-current-balance-line-chart-legends = ->
    ['会员充值','余额消费']

  get-coupons-market-line-chart-legends = ->
    ['浏览次数', '领取次数', '核销次数']

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

      hidden: false

  get-line-chart-datasets  = (color-settings, data, legends, dataset-item)->
    datasets = []

    length = data.length

    for i from 1 to length
      dataset-item.backgroundColor = color-settings.backgroundColors[i]
      dataset-item.borderColor = color-settings.borderColors[i]
      dataset-item.pointHoverBackgroundColor = color-settings.pointHoverBackgroundColors[i]
      dataset-item.data = data[i - 1]
      dataset-item.label = legends[i - 1]

      temp = JSON.parse JSON.stringify(dataset-item) # trick deep clone
      # if i is 0 then temp.hidden = false

      datasets.push temp

    datasets

  get-line-chart-labels = ->
    type = null

    if $scope.selected-tab is 'member'
      type = $scope.filter.member-time-type
    else
      type = $scope.filter.coupons-time-type

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
    date-object = get-selected-date-object-from-date-and-week-type!
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
    date-object = {}
    if $scope.selected-tab is 'member'
      date-object = get-date-object-from-zh-cn-string $scope.filter.member-selected-month
    else
      date-object = get-date-object-from-zh-cn-string $scope.filter.coupons-selected-month
    day-number = get-days-number-of-month date-object.year, date-object.month

    [i + '日' for i from 1 to day-number]

  get-days-number-of-month = (year, month)->
    new Date(year, month, 0).getDate!

  get-year-labels = ->
    ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]

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

  # {year: [,month: ]}
  get-date-object-from-zh-cn-string = (str)->
    year = str.substring(0, str.indexOf('年'))
    month = null
    if str.indexOf('月') isnt -1
      month = str.substring(str.indexOf('年')+1, str.indexOf('月'))

    obj = {}; obj.year = parse-int year
    if month is not null then obj.month = parse-int month

    obj

  get-retrieve-member-data-callback = ->
    retrieve-member-data-callback = (result)!->
      if !$scope.register-time
        $scope.register-time = new Date(result.register_time * 1000)
        $scope.now-time = new Date(result.now * 1000)
        $ '[data-toggle="datepicker"]' .datepicker 'setEndDate', $scope.now-time
        init-all-years-and-all-months!
        # set-datepicker-start-and-end-date!

      $scope.statistic = result.statistic
      set-current-members-data-panel!
      set-member-class-data-panel!
      set-current-balance-data-panel!

      console.log '$scope.statistic: ', $scope.statistic

      # init-chart!
      # set-ready-state!

    retrieve-member-data-callback

  get-retrieve-coupons-data-callback = ->
    retrieve-coupons-data-callback = (result)!->
      debugger
      $scope.coupons = result.statistic
      set-batch-numbers-array!
      console.log $scope.coupons

    retrieve-coupons-data-callback

  # ====== 9 数据访问函数 ======

  # CRUD之Retrieve，date-obj = {year:, month:, date:}
  retrieve-statistics-by-type = (unit, type, date-obj, callback)!->

    set-waiting-state! # loading

    post-data = {} # post请求body内容
    post-data <<< date-obj
    post-data.unit = unit
    post-data.type = type

    result = $scope.resource.statistic.save {}, post-data, !->
      callback? result
      set-ready-state! # 去掉loading
      console.log 'here is retrieve-statistics-by-type'
      init-chart!

  retrieve-member-class-and-sumbalance = !->
    $analysisSM.go-to-state ['\#analysis-main', '\#analysis-spinner']

    callback = (result)!->
      data = JSON.parse result.data
      $scope.member-class = data.distribution
      $scope.sum-balance = data.sum_balance
      $scope.member-count = data.count
      $analysisSM.go-to-state ['\#analysis-main']

    result = $scope.resource.analysis.get {}, !->
      callback result

      if $scope.selected-tab is 'coupons'
        console.log 'retrieve-member-class-and-sumbalance'
        init-chart!

  # ====== 10 初始化函数执行 ======

  init-data-statistic!

]
