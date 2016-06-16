StateMachine = require './../tools/stateMachine-tool.js'

statistics-module = angular.module 'ManageDataStatistics'

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
