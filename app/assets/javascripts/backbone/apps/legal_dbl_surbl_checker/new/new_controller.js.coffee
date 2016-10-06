@Artoo.module 'LegalDblSurblCheckerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->

      @layout = @getLayoutView()
      @show @layout

    getLayoutView: ->
      new New.Layout