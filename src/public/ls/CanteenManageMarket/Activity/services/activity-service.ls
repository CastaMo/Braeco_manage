StateMachine = require './../tools/stateMachine-tool.js'

activity-module = angular.module 'ManageMarketActivity'

# 变量：是否允许console.log
activity-module.value 'allowConsole', false

# 前端console.log服务
activity-module.factory '$braecoConsole', ['allowConsole', (allowConsole)->
  func = null
  if allowConsole
    # http://stackoverflow.com/a/9521992
    func = !-> console.log.apply console, arguments
  else
    func = !->
  func
]


# activity部分状态机配置

activity-state-machine-options =
  initial: ['\#activity-list']
  views: ['\#activity-main', '\#activity-spinner', '\#activity-list']
  transitions: [
    {from: ['\#activity-main'], to: ['\#activity-list'], on: ['.activity-tab click']}
  ]
  show-state: ['activity-fade-in']
  hide-state: ['activity-fade-out']
  init-state: ['activity-init']

activity-module.constant 'activity-state-machine-options', activity-state-machine-options

activity-module.factory '$activitySM', ['activity-state-machine-options', (activity-state-machine-options)->
  new StateMachine activity-state-machine-options
]
