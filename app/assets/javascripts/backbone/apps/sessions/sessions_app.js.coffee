@Artoo.module 'SessionsApp', (SessionsApp, App, Backbone, Marionette, $, _) ->
  
  API =
    
    authRequired: ->
      new SessionsApp.Unauthorized.Controller
      
    accessDenied: ->
      new SessionsApp.AccessDenied.Controller
      
    getNewUserSessionPath: ->
      Routes.new_user_session_path() + "?frag=" + encodeURIComponent("#/" + App.getCurrentRoute())
      
  App.vent.on 'auth:required', ->
    API.authRequired()
    
  App.vent.on 'access:denied', ->
    API.accessDenied()
    
  App.vent.on 'new:user:session:requested', ->
    window.open API.getNewUserSessionPath(), '_self'
    
  App.reqres.setHandler 'new:user:session:path', ->
    API.getNewUserSessionPath()