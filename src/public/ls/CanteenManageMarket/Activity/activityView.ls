# ActivityView类提供单页面内伪路由控制：有限状态机

class View
  @name = 'ActivityView'

  (view)->
    @states = []

  action: ->
    console.log 'This is view action!'

module.exports = View
