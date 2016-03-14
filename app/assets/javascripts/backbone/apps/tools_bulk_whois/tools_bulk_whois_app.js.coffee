@Artoo.module 'ToolsBulkWhoisApp', (ToolsBulkWhoisApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsBulkWhoisApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/bulk_whois' : 'list'
      
  API =
    
    list: (region) ->
      return App.execute 'tools:list', 'Bulk Whois', 'list' if not region
      
      new ToolsBulkWhoisApp.List.Controller
        region: region
        
        
  App.vent.on 'tools:nav:selected', (nav, action, region) ->
    return if nav isnt 'Bulk Whois'
    
    action ?= 'list'
    
    if action is 'list'
      App.navigate '/tools/bulk_whois'
      API.list region
  
  
  ToolsBulkWhoisApp.on 'start', ->
    new ToolsBulkWhoisApp.Router
      controller: API