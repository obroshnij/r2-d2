@Artoo.module 'ToolsApp', (ToolsApp, App, Backbone, Marionette, $, _) ->
  
  API =
    
    list: ->
      App.vent.trigger 'nav:select', 'General Tools'
      new ToolsApp.List.Controller
  
  
  class ToolsApp.Router extends App.Routers.Base
    controller: API
    
    appRoutes:
      'tools' : 'list'
  
  
  ToolsApp.on 'start', ->
    new ToolsApp.Router