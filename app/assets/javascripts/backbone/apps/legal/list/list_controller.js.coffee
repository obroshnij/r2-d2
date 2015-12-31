@Artoo.module "LegalApp.List", (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      legalNavs = App.request 'legal:nav:entities'
      
      @listenTo legalNavs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'legal:nav:selected', model.get('name'), @options.action, @layout.articleRegion
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @breadcrumbsRegion legalNavs
        @navsRegion legalNavs, options.nav
        
      @show @layout
      
    breadcrumbsRegion: (legalNavs) ->
      breadcrumbsView = @getBreadcrumbs legalNavs
      @show breadcrumbsView, region: @layout.breadcrumbsRegion
    
    navsRegion: (legalNavs, nav) ->
      legalNavs.selectByName nav
      legalNavsView = @getLegalNavsView legalNavs
      @show legalNavsView, region: @layout.legalNavsRegion
      
    getBreadcrumbs: (legalNavs) ->
      new List.Breadcrumbs
        collection: legalNavs
    
    getLegalNavsView: (legalNavs) ->
      new List.Navs
        collection: legalNavs
    
    getLayoutView: ->
      new List.Layout