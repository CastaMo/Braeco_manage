StateMachine = require './../tools/stateMachine-tool.js'

statistics-module = angular.module 'ManageDataStatistics'

# 变量：是否允许console.log
statistics-module.value 'allowConsole', false

# 前端console.log服务
statistics-module.factory '$braecoConsole', ['allowConsole', (allowConsole)->
  func = null
  if allowConsole
    # http://stackoverflow.com/a/9521992
    func = !-> console.log.apply console, arguments
  else
    func = !->
  func
]

# statistics部分状态机配置

statistics-state-machine-options =
  initial: ['\#statistics-main', '\#statistics-spinner-circle']
  views: ['\#statistics-main', '\#statistics-spinner-circle']
  transitions: []
  show-state: ['statistics-fade-in']
  hide-state: ['statistics-fade-out']
  init-state: ['statistics-init']

statistics-module.constant 'statistics-state-machine-options', statistics-state-machine-options

statistics-module.factory '$statisticsSM', ['statistics-state-machine-options', (statistics-state-machine-options)->
  new StateMachine statistics-state-machine-options
]
