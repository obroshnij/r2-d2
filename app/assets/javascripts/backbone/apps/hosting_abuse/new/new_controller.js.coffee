@Artoo.module 'HostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      
      report = App.request 'new:hosting:abuse:report:entity'
      
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion(report)

      @show @layout

    formRegion: (report) ->
      formManager = new New.FormManager
      newView = @getNewView formManager.formFields(), report
      
      formView = App.request 'form:wrapper', newView

      @layout.formRegion.show formView
      formManager.manage newView

    getNewView: (fields, report) ->
      new New.FormFields
        collection: fields
        model:      report

    getLayoutView: ->
      new New.Layout