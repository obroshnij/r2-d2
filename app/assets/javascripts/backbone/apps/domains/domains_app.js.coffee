@Artoo.module 'DomainsApp', (DomainsApp, App, Backbone, Marionette, $, _) ->
  
  class DomainsApp.Router extends App.Routers.Base
    
    appRoutes:
      'domains' : 'list'
  
  
  API =
    
    list: (nav, options) ->
      App.vent.trigger 'nav:select', 'Domains'
      new DomainsApp.List.Controller
        nav:     nav
        options: options
  
  
  App.commands.setHandler 'domains:list', (nav, options) ->
    API.list nav, options
  
  
  DomainsApp.on 'start', ->
    new DomainsApp.Router
      controller: API