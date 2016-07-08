
# ====== angular definition ======
ng-app = 'ManageLogin'
ng-app-module = angular.module ng-app, ['ngResource', 'angular-md5']

# ====== angular config ======
ng-app-module.config ['$resourceProvider', ($resourceProvider)->
  $resourceProvider.defaults.stripTrailingSlashes = false
]

# ====== angular filters ======
require './filters/login-filter.js'

# ====== angular services ======
require './services/login-service.js'

# ====== angular controllers ======
require './controllers/login-controller.js'

# ====== angular bootstrap ======
angular.element document .ready !->
  angular.bootstrap document, [ng-app]
