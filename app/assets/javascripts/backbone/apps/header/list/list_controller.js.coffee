@Artoo.module 'HeaderApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { navs } = options
      
      @layout = @getLayout()
      
      @listenTo @layout, 'show', =>
        @topBarRegion navs
        @titleRegion navs
      
      @show @layout
      
    topBarRegion: (navs) ->
      topBarView = @getTopBar navs
      
      @listenTo topBarView, 'sign:in:clicked', ->
        App.vent.trigger 'new:user:session:requested'
      
      @show topBarView, region: @layout.topBarRegion
      
    titleRegion: (navs) ->
      titleView = @getTitle navs
      @show titleView, region: @layout.titleRegion
      
    getTitle: (navs) ->
      new List.Title
        collection: navs
      
    getLayout: ->
      new List.Layout
      
    getTopBar: (navs) ->
      new List.TopBar
        collection: navs