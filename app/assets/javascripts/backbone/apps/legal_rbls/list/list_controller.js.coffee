@Artoo.module 'LegalRblsApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      navs = App.request 'legal:rbls:nav:entities'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @navRegion navs
        
      @listenTo navs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'legal:rbls:nav:selected', model.get('name'), @layout.contentRegion
        
      @show @layout
      
      _.defer => navs.first().select()
        
    navRegion: (navs) ->
      navigationView = @getNavigationView navs
      
      @show navigationView, region: @layout.navRegion
      
    getNavigationView: (navs) ->
      new List.Navigation
        collection: navs
      
    getLayoutView: ->
      new List.Layout
      