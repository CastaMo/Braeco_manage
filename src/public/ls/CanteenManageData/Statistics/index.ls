
# ====== angular definition ======
ng-app = 'ManageDataStatistics'
ng-app-module = angular.module ng-app, ['ngResource']

# ====== angular config ======
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false
]

# ====== angular filters ======
require './filters/statistics-filter.js'

# ====== angular services ======
require './services/statistics-service.js'

# ====== angular controllers ======
require './controllers/statistics-controller.js'

# ====== angular bootstrap ======
angular.element document .ready !->
  angular.bootstrap document, [ng-app]
