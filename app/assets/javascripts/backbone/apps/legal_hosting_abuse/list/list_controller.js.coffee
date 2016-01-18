@Artoo.module 'LegalHostingAbuseApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion()
        @reportsRegion()
      
      @show @layout
      
    panelRegion: ->
      panelView = @getPanelView()
      
      @listenTo panelView, 'submit:report:clicked', ->
        App.vent.trigger 'submit:report:clicked'
      
      @show panelView, region: @layout.panelRegion
      
    searchRegion: ->
      searchView = @getSearchView()
      
      formView = App.request 'form:component', searchView,
        model: false
        
      @listenTo formView, 'form:submit', (data) -> console.log(data)
        
      @show formView, region: @layout.searchRegion
      
    reportsRegion: ->
      reports = App.request 'hosting:abuse:entities'
      
      reportsView = @getReportsView reports
      
      @show reportsView,
        loading: true
        region:  @layout.reportsRegion
      
    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false
      
    getReportsView: (reports) ->
      new List.Reports
        collection: reports
      
    getPanelView: ->
      new List.Panel
      
    getLayoutView: ->
      new List.Layout