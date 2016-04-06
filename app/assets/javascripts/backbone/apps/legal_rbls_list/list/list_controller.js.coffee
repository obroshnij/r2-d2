@Artoo.module 'LegalRblsListApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      rbls = App.request 'legal:rbl:entities'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion rbls
        @rblsRegion rbls
        @paginationRegion rbls
      
      @show @layout
      
    panelRegion: ->
      panelView = @getPanelView()
      
      @show panelView, region: @layout.panelRegion
      
    searchRegion: (rbls) ->
      searchView = @getSearchView()
      
      formView = App.request 'form:component', searchView,
        model: false
        
      @listenTo formView, 'form:submit', (data) ->
        rbls.search data
        
      @show formView, region: @layout.searchRegion
      
    rblsRegion: (rbls) ->
      rblsView = @getRblsView rbls
      
      @listenTo rblsView, 'childview:edit:clicked', (child, args) ->
        App.vent.trigger 'edit:legal:rbl:clicked', args.model
      
      @show rblsView, region: @layout.rblsRegion, loading: true
      
    paginationRegion: (rbls) ->
      pagination = App.request 'pagination:component', rbls
        
      App.execute 'when:synced', rbls, =>
        @show pagination, region: @layout.paginationRegion
      
    getLayoutView: ->
      new List.Layout
      
    getPanelView: ->
      new List.Panel
      
    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false
        
    getRblsView: (rbls) ->
      new List.Rbls
        collection: rbls