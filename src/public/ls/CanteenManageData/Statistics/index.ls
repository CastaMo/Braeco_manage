# ========== 初始化 =========
ng-app = 'ManageDataStatistics'
ng-app-module = angular.module ng-app, ['ngResource']
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false;
]

# ========== 加载外部模块 ===========
statistics-init = require './statisticsInit.js'

# ========== 手动引导ng-app ===========
angular.element document .ready !->
  angular.bootstrap document, [ng-app]

# ========== 页面加载初始化操作 ===========

# ========== 工具函数 ========
chart-init = !->
  ctx = document.getElementById("myChart");
  myChart = new Chart ctx, opt = 
    type: 'bar'
    data:
      labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"]
      datasets: [{
        label: '# of Votes'
        data: [12, 19, 3, 5, 2, 3]
        backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
          'rgba(54, 162, 235, 0.2)',
          'rgba(255, 206, 86, 0.2)',
          'rgba(75, 192, 192, 0.2)',
          'rgba(153, 102, 255, 0.2)',
          'rgba(255, 159, 64, 0.2)'
        ]
        borderColor: [
          'rgba(255,99,132,1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 159, 64, 1)'
        ]
        borderWidth: 1
      }]
    options:
      scales:
        yAxes: [{
          ticks: {
            beginAtZero:true
          }
        }]

# =============== 控制器 ================
ng-app-module.controller 'data-statistics', ['$scope', '$resource', ($scope, $resource)!->

  # ====== $scope变量 ======
  $scope.view = null

  # ====== 页面加载初始化操作 =======
  statistics-init.page-init!
  chart-init!
  $scope.view = statistics-init.get-statistics-view!

  # ====== DOM操作 ======


  # ====== $scope事件 ======


]