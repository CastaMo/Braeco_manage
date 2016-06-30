StateMachine = require './../tools/stateMachine-tool.js'

analysis-module = angular.module 'ManageDataAnalysis'

# analysis部分状态机配置

analysis-state-machine-options =
  initial: ['\#analysis-main']
  views: ['\#analysis-main', '\#analysis-spinner']
  transitions: []
  show-state: ['analysis-fade-in']
  hide-state: ['analysis-fade-out']
  init-state: ['analysis-init']

analysis-module.constant 'analysis-state-machine-options', analysis-state-machine-options

analysis-module.factory '$analysisSM', ['analysis-state-machine-options', (analysis-state-machine-options)->
  new StateMachine analysis-state-machine-options
]
