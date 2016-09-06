@Artoo.module 'UserManagementRolesApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      roles = App.request 'role:entities'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion roles
        @rolesRegion roles
        @paginationRegion roles
        
      @show @layout
      
    panelRegion: ->
      panelView = @getPanelView()
      
      @listenTo panelView, 'new:role:clicked', ->
        App.vent.trigger 'new:role:clicked'
      
      @show panelView, region: @layout.panelRegion
      
    searchRegion: (roles) ->
      searchView = @getSearchView()
      
      formView = App.request 'form:component', searchView,
        model: false
        
      @listenTo formView, 'form:submit', (data) ->
        roles.search data
        
      @show formView, region: @layout.searchRegion
      
    rolesRegion: (roles) ->
      rolesView = @getRolesView roles
      
      @listenTo rolesView, 'childview:edit:groups:clicked', (child, args) ->
        App.vent.trigger 'edit:groups:clicked', args.model
        
      @listenTo rolesView, 'childview:edit:permissions:clicked', (child, args) ->
        App.vent.trigger 'edit:permissions:clicked', args.model
        
      @listenTo rolesView, 'childview:destroy:role:clicked', (child, args) ->
        model = args.model
        if confirm "Are you sure you want to delete #{model.get("name")}?" then model.destroy() else false
        
      @show rolesView,
        loading: true
        region:  @layout.rolesRegion
        
    paginationRegion: (roles) ->
      pagination = App.request 'pagination:component', roles
        
      App.execute 'when:synced', roles, =>
        @show pagination, region: @layout.paginationRegion if @layout.paginationRegion
        
    getRolesView: (roles) ->
      new List.RolesView
        collection: roles
      
    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false
      
    getPanelView: ->
      new List.Panel
      
    getLayoutView: ->
      new List.Layout