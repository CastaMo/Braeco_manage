
View = require './statisticsView.js'

statistics-init = let

  module =
    get-statistics-view: ->
      view = new View options =
        initial: ['\#statistics-main', '\#statistics-spinner-circle']
        views: ['\#statistics-main', '\#statistics-spinner-circle']
        transitions: []
        show-state: ['statistics-fade-in']
        hide-state: ['statistics-fade-out']
        init-state: ['statistics-init']
      view

module.exports = statistics-init
