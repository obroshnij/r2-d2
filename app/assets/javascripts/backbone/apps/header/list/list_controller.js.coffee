@Artoo.module 'HeaderApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { navs } = options
      
      @layout = @getLayout()
      
      @listenTo @layout, 'show', =>
        @topBarRegion navs
      
      @show @layout
      
    topBarRegion: (navs) ->
      topBarView = @getTopBar navs
      
      @listenTo topBarView, 'sign:in:clicked', ->
        App.vent.trigger 'new:user:session:requested'
      
      @show topBarView, region: @layout.topBarRegion
      
    getLayout: ->
      new List.Layout
      
    getTopBar: (navs) ->
      new List.TopBar
        collection: navs