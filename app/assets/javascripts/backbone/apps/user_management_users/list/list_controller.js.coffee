@Artoo.module 'UserManagementUsersApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      users = App.request 'user:entities'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion users
        @usersRegion users
        @paginationRegion users
        
      @show @layout
      
    panelRegion: ->
      panelView = @getPanelView()
            
      @show panelView, region: @layout.panelRegion
      
    searchRegion: (users) ->
      searchView = @getSearchView()
      
      formView = App.request 'form:component', searchView,
        model: false
        
      @listenTo formView, 'form:submit', (data) ->
        users.search data
        
      @show formView, region: @layout.searchRegion
      
    usersRegion: (users) ->
      usersView = @getUsersView users
      
      @show usersView,
        loading: true
        region:  @layout.usersRegion
        
    paginationRegion: (users) ->
      pagination = App.request 'pagination:component', users
        
      App.execute 'when:synced', users, =>
        @show pagination, region: @layout.paginationRegion
      
    getUsersView: (users) ->
      new List.UsersView
        collection: users
      
    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false
      
    getPanelView: ->
      new List.Panel
      
    getLayoutView: ->
      new List.Layout