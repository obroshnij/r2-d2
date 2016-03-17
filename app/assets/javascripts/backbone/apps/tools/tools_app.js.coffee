@Artoo.module 'ToolsApp', (ToolsApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools' : 'list'
  
  
  API =
    
    list: (nav, options) ->
      App.vent.trigger 'nav:select', 'Tools'
      new ToolsApp.List.Controller
        nav:     nav
        options: options
  
  
  App.commands.setHandler 'tools:list', (nav, options) ->
    API.list nav, options
  
  
  ToolsApp.on 'start', ->
    new ToolsApp.Router
      controller: API