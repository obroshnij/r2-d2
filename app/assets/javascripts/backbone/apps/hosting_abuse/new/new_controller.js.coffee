@Artoo.module 'HostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      
      report = App.request 'new:hosting:abuse:report:entity'
      
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion(report)

      @show @layout

    formRegion: (report) ->
      newView = @getNewView report
      formView = App.request 'wrap:form', newView
      @layout.formRegion.show formView

    getNewView: (report) ->
      new New.FormFields
        model: report

    getLayoutView: ->
      new New.Layout