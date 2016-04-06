@Artoo.module 'LegalRblsCheckerApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @formRegion()
        
      @show @layout
      
    formRegion: ->
      
    panelRegion: ->
      panelView = @getPanelView()
      
      @show panelView, region: @layout.panelRegion
      
    getPanelView: ->
      new New.Panel
      
    getLayoutView: ->
      new New.Layout