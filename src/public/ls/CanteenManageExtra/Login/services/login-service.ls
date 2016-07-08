StateMachine = require './../tools/stateMachine-tool.js'

login-module = angular.module 'ManageLogin'

# 变量：是否允许console.log
login-module.value 'allowConsole', true

# 前端console.log服务
login-module.factory '$braecoConsole', ['allowConsole', (allowConsole)->
  func = null
  if allowConsole
    # http://stackoverflow.com/a/9521992
    func = !-> console.log.apply console, arguments
  else
    func = !->
  func
]

# login部分状态机配置

login-state-machine-options =
  initial: []
  views: []
  transitions: []
  show-state: []
  hide-state: []
  init-state: []

login-module.constant 'login-state-machine-options', login-state-machine-options

login-module.factory '$loginSM', ['login-state-machine-options', (login-state-machine-options)->
  new StateMachine login-state-machine-options
]
