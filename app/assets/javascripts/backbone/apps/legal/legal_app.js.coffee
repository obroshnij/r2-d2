@Artoo.module 'LegalApp', (LegalApp, App, Backbone, Marionette, $, _) ->
  
  class LegalApp.Router extends App.Routers.Base
    
    appRoutes:
      'legal' : 'list'
  
  
  API =
    
    list: (nav, action) ->
      App.vent.trigger 'nav:select', 'Legal & Abuse'
      new LegalApp.List.Controller
        nav:    nav
        action: action
      
      
  App.commands.setHandler 'legal:list', (nav, action) ->
    API.list nav, action
  
  
  LegalApp.on 'start', ->
    new LegalApp.Router
      controller: API