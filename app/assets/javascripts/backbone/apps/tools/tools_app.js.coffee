@Artoo.module 'ToolsApp', (ToolsApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools' : 'list'
  
  
  API =
    
    list: (nav, action) ->
      App.vent.trigger 'nav:select', 'Tools'
      new ToolsApp.List.Controller
        nav:    nav
        action: action
  
  
  App.commands.setHandler 'tools:list', (nav, action) ->
    API.list nav, action
  
  
  ToolsApp.on 'start', ->
    new ToolsApp.Router
      controller: API