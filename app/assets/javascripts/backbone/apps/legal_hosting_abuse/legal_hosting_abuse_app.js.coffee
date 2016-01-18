@Artoo.module 'LegalHostingAbuseApp', (LegalHostingAbuseApp, App, Backbone, Marionette, $, _) ->
  
  class LegalHostingAbuseApp.Router extends App.Routers.Base
    
    appRoutes:
      'legal/hosting_abuse'     : 'list'
      'legal/hosting_abuse/new' : 'newReport'
  
  
  API =
    
    list: (region) ->
      return App.execute 'legal:list', 'Hosting Abuse', 'list' if not region
      
      new LegalHostingAbuseApp.List.Controller
        region: region
    
    newReport: (region) ->
      return App.execute 'legal:list', 'Hosting Abuse', 'newReport' if not region
      
      new LegalHostingAbuseApp.New.Controller
        region: region
  
  
  App.vent.on 'legal:nav:selected', (nav, action, region) ->
    return if nav isnt 'Hosting Abuse'
    
    action ?= 'list'
    
    if action is 'list'
      App.navigate '/legal/hosting_abuse'
      API.list region
      
    if action is 'newReport'
      App.navigate '/legal/hosting_abuse/new'
      API.newReport region
    
  App.vent.on 'submit:report:clicked', ->
    API.newReport()
    
  App.vent.on 'new:report:cancelled', ->
    API.list()
    
  App.vent.on 'hosting:abuse:created', (report) ->
    API.list()
  
  
  LegalHostingAbuseApp.on 'start', ->
    new LegalHostingAbuseApp.Router
      controller: API
      auth:       true
      resource:   'Legal::HostingAbuse'