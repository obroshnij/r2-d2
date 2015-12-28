@Artoo.module 'LegalApp', (LegalApp, App, Backbone, Marionette, $, _) ->
  
  class LegalApp.Router extends App.Routers.Base
    
    appRoutes:
      'legal' : 'list'
  
  
  API =
    
    list: (nav) ->
      App.vent.trigger 'nav:select', 'Legal & Abuse'
      new LegalApp.List.Controller
        nav: nav
      
      
  App.commands.setHandler 'legal:list', (nav) ->
    API.list nav
  
  LegalApp.on 'start', ->
    new LegalApp.Router
      controller: API