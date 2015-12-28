@Artoo.module 'LegalHostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      report = App.request 'new:hosting:abuse:report:entity'
      
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion(report)

      @show @layout

    formRegion: (report) ->
      newView  = @getNewView()
      
      form = App.request 'form:component', newView,
        model: report
      
      @show form, region: @layout.formRegion

    getNewView: ->
      new New.Report

    getLayoutView: ->
      new New.Layout