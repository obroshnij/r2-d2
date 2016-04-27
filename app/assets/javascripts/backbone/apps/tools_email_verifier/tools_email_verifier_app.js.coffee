@Artoo.module 'ToolsEmailVerifierApp', (ToolsEmailVerifierApp, App, Backbone, Marionette, $, _) ->
  
  class ToolsEmailVerifierApp.Router extends App.Routers.Base
    
    appRoutes:
      'tools/email_verifier' : 'newCheck'
  
  API =
  
    newCheck: (region) ->
      return App.execute 'tools:list', 'Email Verifier', { action: 'newCheck' } if not region
    
      new ToolsEmailVerifierApp.New.Controller
        region: region
        
    showSmtpSession: (email, session) ->
      new ToolsEmailVerifierApp.ShowSmtp.Controller
        region:  App.modalRegion
        email:   email
        session: session
  
  
  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Email Verifier'
    
    action = options?.action
    action ?= 'newCheck'
      
    if action is 'newCheck'
      App.navigate '/tools/email_verifier'
      API.newCheck region
      
  App.vent.on 'show:smtp:session', (email, session) ->
    API.showSmtpSession email, session
  
  
  ToolsEmailVerifierApp.on 'start', ->
    new ToolsEmailVerifierApp.Router
      controller: API