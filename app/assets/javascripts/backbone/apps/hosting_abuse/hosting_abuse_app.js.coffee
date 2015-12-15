@Artoo.module 'HostingAbuseApp', (HostingAbuseApp, App, Backbone, Marionette, $, _) ->
  
  API =
    
    newReport: ->
      new HostingAbuseApp.New.Controller
    
  class HostingAbuseApp.Router extends App.Routers.Base
    controller: API
    
    appRoutes:
      'hosting_abuse_reports/new' : 'newReport'
    
  HostingAbuseApp.on 'start', ->
    new HostingAbuseApp.Router