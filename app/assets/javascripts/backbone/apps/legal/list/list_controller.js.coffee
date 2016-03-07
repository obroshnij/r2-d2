@Artoo.module "LegalApp.List", (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      legalNavs = App.request 'legal:nav:entities'
      
      return App.vent.trigger 'access:denied' if legalNavs.length is 0
      
      @listenTo legalNavs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'legal:nav:selected', model.get('name'), @options.options, @layout.articleRegion
            
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @titleRegion()
        @breadcrumbsRegion legalNavs
        @navsRegion legalNavs, options.nav
      
      @show @layout
      
      delete @options.options # action is only needed once, when the app is initiated
      
    titleRegion: ->
      titleView = @getTitleView()
      @show titleView, region: @layout.titleRegion
      
    breadcrumbsRegion: (legalNavs) ->
      breadcrumbsView = @getBreadcrumbs legalNavs
      @show breadcrumbsView, region: @layout.breadcrumbsRegion
    
    navsRegion: (legalNavs, nav) ->
      legalNavs.selectByName nav
      legalNavsView = @getLegalNavsView legalNavs
      @show legalNavsView, region: @layout.legalNavsRegion
      
    getTitleView: ->
      new List.Title
      
    getBreadcrumbs: (legalNavs) ->
      new List.Breadcrumbs
        collection: legalNavs
    
    getLegalNavsView: (legalNavs) ->
      new List.Navs
        collection: legalNavs
    
    getLayoutView: ->
      new List.Layout