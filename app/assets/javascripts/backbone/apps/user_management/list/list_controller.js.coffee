@Artoo.module 'UserManagementApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      userManagementNavs = App.request 'user:management:nav:entities'
      
      @listenTo userManagementNavs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'user:management:nav:selected', model.get('name'), @options.options, @layout.articleRegion
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @titleRegion()
        @breadcrumbsRegion userManagementNavs
        @navsRegion userManagementNavs, options.nav
        
      @show @layout
      
      delete @options.options # action is only needed once, when the app is initiated
      
    titleRegion: ->
      titleView = @getTitleView()
      @show titleView, region: @layout.titleRegion
      
    breadcrumbsRegion: (userManagementNavs) ->
      breadcrumbsView = @getBreadcrumbs userManagementNavs
      @show breadcrumbsView, region: @layout.breadcrumbsRegion
      
    navsRegion: (userManagementNavs, nav) ->
      userManagementNavs.selectByName nav
      toolsNavsView = @getUserManagementNavsView userManagementNavs
      @show toolsNavsView, region: @layout.userManagementNavsRegion
      
    getTitleView: ->
      new List.Title
      
    getBreadcrumbs: (toolsNavs) ->
      new List.Breadcrumbs
        collection: toolsNavs
        
    getUserManagementNavsView: (userManagementNavs) ->
      new List.Navs
        collection: userManagementNavs
      
    getLayoutView: ->
      new List.Layout