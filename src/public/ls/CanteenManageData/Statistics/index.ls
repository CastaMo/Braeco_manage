
# ====== angular definition ======
ng-app = 'ManageDataStatistics'
ng-app-module = angular.module ng-app, ['ngResource']

# ====== angular config ======
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false
]

# ====== angular filter ======
require './statistics-filter.js'

# ====== angular service ======
require './statistics-service.js'

# ====== angular controller ======
require './statistics-controller.js'

# ====== angular bootstrap ======
angular.element document .ready !->
  angular.bootstrap document, [ng-app]
