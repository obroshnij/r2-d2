@Artoo.module 'ToolsDataExtractorApp', (ToolsDataExtractorApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsDataExtractorApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/data_extractor' : 'newSearch'
  
  API =
  
    newSearch: (region) ->
      return App.execute 'tools:list', 'Data Extractor', 'newSearch' if not region
    
      new ToolsDataExtractorApp.New.Controller
        region: region
  
  
  App.vent.on 'tools:nav:selected', (nav, action, region) ->
    return if nav isnt 'Data Extractor'
    
    action ?= 'newSearch'
      
    if action is 'newSearch'
      App.navigate '/tools/data_extractor'
      API.newSearch region
  
  
  ToolsDataExtractorApp.on 'start', ->
    new ToolsDataExtractorApp.Router
      controller: API