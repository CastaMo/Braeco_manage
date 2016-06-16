StateMachine = require './../tools/stateMachine-tool.js'

activity-module = angular.module 'ManageMarketActivity'

# activity部分状态机配置

activity-state-machine-options =
  initial: ['\#activity-main']
  views: ['\#activity-main', '\#upload-canteen-image', '\#activity-spinner']
  transitions: [
    {
      from: ['\#activity-main']
      to: ['\#activity-main', '\#upload-canteen-image']
      on: ['.upload-canteen-photo click']
    },
    {
      from: ['\#activity-main', '\#upload-canteen-image']
      to: ['\#activity-main']
      on: ['.upload-canteen-image-mask click', '.upload-canteen-image-close click', '\#canteen-image-cancel click']
    }
  ]
  show-state: ['activity-fade-in']
  hide-state: ['activity-fade-out']
  init-state: ['activity-init']

activity-module.constant 'activity-state-machine-options', activity-state-machine-options

activity-module.factory '$activitySM', ['activity-state-machine-options', (activity-state-machine-options)->
  new StateMachine activity-state-machine-options
]
