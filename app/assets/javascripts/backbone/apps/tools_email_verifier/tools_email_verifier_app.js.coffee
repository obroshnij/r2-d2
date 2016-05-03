@Artoo.module 'ToolsEmailVerifierApp', (ToolsEmailVerifierApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsEmailVerifierApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/email_verifier' : 'newCheck'
  
  API =
  
    newCheck: (region) ->
      return App.execute 'tools:list', 'Email Verifier', { action: 'newCheck' } if not region
    
      new ToolsEmailVerifierApp.New.Controller
        region: region
        
    showSmtpSession: (record) ->
      new ToolsEmailVerifierApp.ShowSmtp.Controller
        region:  App.modalRegion
        record:  record
  
  
  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Email Verifier'
    
    action = options?.action
    action ?= 'newCheck'
      
    if action is 'newCheck'
      App.navigate '/tools/email_verifier'
      API.newCheck region
      
  App.vent.on 'show:smtp:session', (record) ->
    API.showSmtpSession record
  
  
  ToolsEmailVerifierApp.on 'start', ->
    new ToolsEmailVerifierApp.Router
      controller: API