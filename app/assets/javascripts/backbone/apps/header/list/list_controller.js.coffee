@Artoo.module 'HeaderApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: ->
      listView = @getListView()
      
      @listenTo listView, 'sign:in:clicked', ->
        App.vent.trigger 'new:user:session:requested'
      
      @show listView
      
    getListView: ->
      new List.Header