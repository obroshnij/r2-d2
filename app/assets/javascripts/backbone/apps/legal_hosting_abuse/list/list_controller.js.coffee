@Artoo.module 'LegalHostingAbuseApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      reports = App.request 'hosting:abuse:entities'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion reports
        @reportsRegion reports
        @paginationRegion reports
      
      @show @layout
      
    panelRegion: ->
      panelView = @getPanelView()
      
      @listenTo panelView, 'submit:report:clicked', ->
        App.vent.trigger 'submit:report:clicked'
      
      @show panelView, region: @layout.panelRegion
      
    searchRegion: (reports) ->
      searchView = @getSearchView()
      
      formView = App.request 'form:component', searchView,
        model: false
        
      @listenTo formView, 'form:submit', (data) ->
        reports.search data
        
      @show formView, region: @layout.searchRegion
      
    reportsRegion: (reports) ->
      reportsView = @getReportsView reports
      
      @listenTo reportsView, 'childview:edit:hosting:abuse:clicked', (child, args) ->
        App.vent.trigger 'edit:hosting:abuse:clicked', args.model
        
      @listenTo reportsView, 'childview:process:hosting:abuse:clicked', (child, args) ->
        App.vent.trigger 'process:hosting:abuse:clicked', args.model
      
      @listenTo reportsView, 'childview:dismiss:hosting:abuse:clicked', (child, args) ->
        App.vent.trigger 'dismiss:hosting:abuse:clicked', args.model
      
      @show reportsView,
        loading: true
        region:  @layout.reportsRegion
        
    paginationRegion: (reports) ->
      pagination = App.request 'pagination:component', reports
        
      App.execute 'when:synced', reports, =>
        @show pagination, region: @layout.paginationRegion
      
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