@Artoo.module 'DomainsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      domainsNavs = App.request 'domains:nav:entities'
      
      @listenTo domainsNavs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'domains:nav:selected', model.get('name'), @options.options, @layout.articleRegion
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @titleRegion()
        @breadcrumbsRegion domainsNavs
        @navsRegion domainsNavs, options.nav
        
      @show @layout
      
      delete @options.options # action is only needed once, when the app is initiated
      
    titleRegion: ->
      titleView = @getTitleView()
      @show titleView, region: @layout.titleRegion
      
    breadcrumbsRegion: (domainsNavs) ->
      breadcrumbsView = @getBreadcrumbs domainsNavs
      @show breadcrumbsView, region: @layout.breadcrumbsRegion
      
    navsRegion: (domainsNavs, nav) ->
      domainsNavs.selectByName nav
      domainsNavsView = @getDomainsNavsView domainsNavs
      @show domainsNavsView, region: @layout.domainsNavsRegion
      
    getTitleView: ->
      new List.Title
      
    getBreadcrumbs: (domainsNavs) ->
      new List.Breadcrumbs
        collection: domainsNavs
        
    getDomainsNavsView: (domainsNavs) ->
      new List.Navs
        collection: domainsNavs
      
    getLayoutView: ->
      new List.Layout