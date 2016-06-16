
# ====== angular definition ======
ng-app = 'ManageMarketActivity'
ng-app-module = angular.module ng-app, ['ngResource']

# ====== angular config ======
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false;
]

# ====== angular filters ======
require './filters/activity-filter.js'

# ====== angular services ======
require './services/activity-service.js'

# ====== angular controllers ======
require './controllers/activityMain-controller.js'
require './controllers/activityCanteenImage-controller.js'

# ====== angular bootstrap ======
angular.element document .ready !->
  angular.bootstrap document, [ng-app]
