@Artoo.module 'ToolsListsDiffApp', (ToolsListsDiffApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsListsDiffApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/lists_diff' : 'newDiff'
      
  API =
    
    newDiff: (region) ->
      return App.execute 'tools:list', 'Lists Compare Tool', 'newDiff' if not region
      
      new ToolsListsDiffApp.New.Controller
        region: region
        
        
  App.vent.on 'tools:nav:selected', (nav, action, region) ->
    return if nav isnt 'Lists Compare Tool'
    
    action ?= 'newDiff'
      
    if action is 'newDiff'
      App.navigate '/tools/lists_diff'
      API.newDiff region
  
  
  ToolsListsDiffApp.on 'start', ->
    new ToolsListsDiffApp.Router
      controller: API
      auth:       false