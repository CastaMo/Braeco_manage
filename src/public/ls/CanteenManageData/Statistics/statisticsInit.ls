
View = require './statisticsView.js'

statistics-init = let
  
  module = 
    page-init: !->
      $ '[data-toggle="datepicker"]' .datepicker {language: 'zh-CN'}
      $ "\#Data-sub-menu" .add-class "choose"

    get-statistics-view: ->
      view = new View options =
        initial: ['\#statistics-main']
        views: ['\#statistics-main', '\#statistics-spinner']
        transitions: []
        show-state: ['statistics-fade-in']
        hide-state: ['statistics-fade-out']
        init-state: ['statistics-init']
      view

module.exports = statistics-init
