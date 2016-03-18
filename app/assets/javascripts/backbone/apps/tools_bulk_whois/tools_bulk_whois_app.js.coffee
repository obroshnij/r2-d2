@Artoo.module 'ToolsBulkWhoisApp', (ToolsBulkWhoisApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsBulkWhoisApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/bulk_whois'     : 'list'
      'tools/bulk_whois/:id' : 'show'
      
  API =
    
    list: (region) ->
      return App.execute 'tools:list', 'Bulk Whois', { action: 'list' } if not region
      
      new ToolsBulkWhoisApp.List.Controller
        region: region
        
    show: (id, region) ->
      return App.execute 'tools:list', 'Bulk Whois', { action: 'show', id: id } if not region
      
      new ToolsBulkWhoisApp.Show.Controller
        region: region
        id:     id
        
    showRawWhois: (record) ->
      new ToolsBulkWhoisApp.ShowRaw.Controller
        region: App.modalRegion
        record: record
        
        
  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Bulk Whois'
    
    action = options?.action
    action ?= 'list'
    
    if action is 'list'
      App.navigate '/tools/bulk_whois'
      API.list region
      
    if action is 'show'
      App.navigate "/tools/bulk_whois/#{options.id}"
      API.show options.id, region
      
  App.vent.on 'show:bulk:whois:lookup:clicked', (lookup) ->
    API.show lookup.id
    
  App.vent.on 'show:raw:whois', (record) ->
    API.showRawWhois record
  
  
  ToolsBulkWhoisApp.on 'start', ->
    new ToolsBulkWhoisApp.Router
      controller: API