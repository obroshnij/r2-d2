@Artoo.module 'HeaderApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: ->
      navs = App.request 'nav:entities'
      
      listView = @getListView navs
      
      @listenTo listView, 'sign:in:clicked', ->
        App.vent.trigger 'new:user:session:requested'
      
      @show listView
      
    getListView: (navs) ->
      new List.Header
        collection: navs