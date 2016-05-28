# Activity类，用来管理MVC和Resource

class Activity
  @name = 'Activity'

  (data)->
    Model = require './activityModel.js'
    View = require './activityView.js'
    Controller = require './activityController.js'
    Resource = require './activityResource.js'

    @model = new Model
    @view = new View
    @controller = new Controller
    @resource = new Resource

  action: !->
    @model.action!
    @view.action!
    @controller.action!
    @resource.action!

module.exports = Activity
