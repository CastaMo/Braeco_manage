
# ====== angular definition ======
ng-app = 'ManageDataAnalysis'
ng-app-module = angular.module ng-app, ['ngResource']

# ====== angular config ======
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false
]

# ====== angular filters ======
require './filters/analysis-filter.js'

# ====== angular services ======
require './services/analysis-service.js'

# ====== angular controllers ======
require './controllers/analysis-controller.js'

# ====== angular bootstrap ======
angular.element document .ready !->
  angular.bootstrap document, [ng-app]
