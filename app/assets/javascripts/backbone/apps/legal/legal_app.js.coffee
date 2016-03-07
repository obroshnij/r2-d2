@Artoo.module 'LegalApp', (LegalApp, App, Backbone, Marionette, $, _) ->
  
  class LegalApp.Router extends App.Routers.Base
    
    appRoutes:
      'legal' : 'list'
  
  
  API =
    
    list: (nav, options) ->
      App.vent.trigger 'nav:select', 'Legal & Abuse'
      new LegalApp.List.Controller
        nav:     nav
        options: options
      
      
  App.commands.setHandler 'legal:list', (nav, options) ->
    API.list nav, options
  
  
  LegalApp.on 'start', ->
    new LegalApp.Router
      controller: API