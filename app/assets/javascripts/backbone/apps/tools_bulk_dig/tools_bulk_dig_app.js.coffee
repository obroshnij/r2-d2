@Artoo.module 'ToolsBulkDigApp', (ToolsBulkDigApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsBulkDigApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/bulk_dig' : 'newDig'
      
  API =
    
    newDig: (region) ->
      return App.execute 'tools:list', 'Bulk Dig', { action: 'newDig' } if not region
      
      new ToolsBulkDigApp.New.Controller
        region: region
        
        
  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Bulk Dig'
    
    action = options?.action
    action ?= 'newDig'
      
    if action is 'newDig'
      App.navigate '/tools/bulk_dig'
      API.newDig region
  
  
  ToolsBulkDigApp.on 'start', ->
    new ToolsBulkDigApp.Router
      controller: API