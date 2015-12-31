@Artoo.module 'LegalHostingAbuseApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @reportsRegion()
      
      @show @layout
      
    panelRegion: ->
      panelView = @getPanelView()
      
      @listenTo panelView, 'submit:report:clicked', ->
        App.vent.trigger 'submit:report:clicked'
      
      @show panelView, region: @layout.panelRegion
      
    reportsRegion: ->
      reportsView = @getReportsView()
      @show reportsView, region: @layout.reportsRegion
      
    getReportsView: ->
      new List.Reports
      
    getPanelView: ->
      new List.Panel
      
    getLayoutView: ->
      new List.Layout