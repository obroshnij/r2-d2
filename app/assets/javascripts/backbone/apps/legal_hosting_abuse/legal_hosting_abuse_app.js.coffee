@Artoo.module 'LegalHostingAbuseApp', (LegalHostingAbuseApp, App, Backbone, Marionette, $, _) ->
  
  class LegalHostingAbuseApp.Router extends App.Routers.Base
    
    appRoutes:
      'legal/hosting_abuse/new' : 'newReport'
  
  
  API =
    
    newReport: (region) ->
      return App.execute 'legal:list', 'Hosting Abuse' if not region
      
      new LegalHostingAbuseApp.New.Controller
        region: region
  
  
  App.vent.on 'legal:nav:selected', (nav, region) ->
    return if nav isnt 'Hosting Abuse'
    
    App.navigate '/legal/hosting_abuse/new'
    API.newReport region
    
  
  LegalHostingAbuseApp.on 'start', ->
    new LegalHostingAbuseApp.Router
      controller: API