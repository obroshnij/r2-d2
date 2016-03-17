@Artoo.module 'ToolsWhoisApp', (ToolsWhoisApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsWhoisApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/whois' : 'newLookup'
      
  API =
    
    newLookup: (region) ->
      return App.execute 'tools:list', 'Whois', { action: 'newLookup' } if not region
      
      new ToolsWhoisApp.New.Controller
        region: region
        
        
  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Whois'
    
    action = options?.action
    action ?= 'newLookup'
      
    if action is 'newLookup'
      App.navigate '/tools/whois'
      API.newLookup region
  
  
  ToolsWhoisApp.on 'start', ->
    new ToolsWhoisApp.Router
      controller: API