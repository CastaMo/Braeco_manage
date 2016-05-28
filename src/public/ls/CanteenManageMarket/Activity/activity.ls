# 'use strict';

# Activity类，用来管理MVC和Resource

class Activity
  (data)->
    @Model = require './activityModel.js'
    @View = require './activityView.js'
    @Controller = require './activityController.js'
    @Resource = require './activityResource.js'

    @action!

  init-model: !->
    @model = new @Model

  init-view: !->
    @view = new @View options =
      initial: ['\#category-main']
      views: ['\#category-main', '\#upload-canteen-image']
      transitions: [
        {
          from: ['\#category-main']
          to: ['\#category-main', '\#upload-canteen-image']
          on: ['.upload-canteen-photo click']
        },
        {
          from: ['\#category-main', '\#upload-canteen-image']
          to: ['\#category-main']
          on: ['.upload-canteen-image-mask click']
        }
      ]
      show-state: ['activity-fade-in']
      hide-state: ['activity-fade-out']
      init-state: ['activity-init']

  init-controller: !->
    @controller = new @Controller

  init-resource: !->
    @resource = new @Resource

  action: !->
    @init-model!
    @init-view!
    @init-controller!
    @init-resource!

module.exports = Activity
