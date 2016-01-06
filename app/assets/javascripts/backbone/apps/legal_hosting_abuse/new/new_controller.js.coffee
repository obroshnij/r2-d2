@Artoo.module 'LegalHostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      report = App.request 'new:hosting:abuse:entity'
      
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion(report)

      @show @layout

    formRegion: (report) ->
      newView  = @getNewView report
      
      form = App.request 'form:component', newView,
        model: report
      
      @show form, region: @layout.formRegion

    getNewView: (report) ->
      schema = new New.FormSchema
      App.request 'form:fields:component', 
        schema: schema,
        model:  report

    getLayoutView: ->
      new New.Layout