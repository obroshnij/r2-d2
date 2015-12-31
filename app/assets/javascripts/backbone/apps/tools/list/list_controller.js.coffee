@Artoo.module 'ToolsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      toolsNavs = App.request 'tools:nav:entities'
      
      @listenTo toolsNavs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'tools:nav:selected', model.get('name'), @options.action, @layout.articleRegion
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @breadcrumbsRegion toolsNavs
        @navsRegion toolsNavs, options.nav
        
      @show @layout
      
    breadcrumbsRegion: (toolsNavs) ->
      breadcrumbsView = @getBreadcrumbs toolsNavs
      @show breadcrumbsView, region: @layout.breadcrumbsRegion
      
    navsRegion: (toolsNavs, nav) ->
      toolsNavs.selectByName nav
      toolsNavsView = @getToolsNavsView toolsNavs
      @show toolsNavsView, region: @layout.toolsNavsRegion
      
    getBreadcrumbs: (toolsNavs) ->
      new List.Breadcrumbs
        collection: toolsNavs
        
    getToolsNavsView: (toolsNavs) ->
      new List.Navs
        collection: toolsNavs
      
    getLayoutView: ->
      new List.Layout