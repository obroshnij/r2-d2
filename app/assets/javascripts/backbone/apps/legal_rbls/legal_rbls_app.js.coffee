@Artoo.module 'LegalRblsApp', (LegalRblsApp, App, Backbone, Marionette, $, _) ->
  
  class LegalRblsApp.Router extends App.Routers.Base
    
    appRoutes:
      'legal/rbls' : 'list'
      
  API =
    
    list: (region) ->
      return App.execute 'legal:list', 'Multi RBL', { action: 'list' } if not region
      
      new LegalRblsApp.List.Controller
        region: region
        
  
  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'Multi RBL'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/legal/rbls'
      API.list region
      
  
  LegalRblsApp.on 'start', ->
    new LegalRblsApp.Router
      controller: API
      resource:   'Legal::Rbl'