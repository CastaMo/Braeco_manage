# ====== angular 过滤器定义 ======

# 数据过滤器
angular.module 'ManageDataStatistics' .filter 'datafilter', ->

  datafilter = (data)->
    if data is undefined or data is null
      return 0
    else return data

  datafilter
