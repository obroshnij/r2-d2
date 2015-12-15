@Artoo.module 'SessionsApp', (SessionsApp, App, Backbone, Marionette, $, _) ->
  
  API =
    
    unauthorized: ->
      new SessionsApp.Unauthorized.Controller
      
    getNewUserSessionPath: ->
      Routes.new_user_session_path() + "?frag=" + encodeURIComponent("#/" + App.getCurrentRoute())
      
  App.vent.on 'auth:required', ->
    API.unauthorized()
    
  App.vent.on 'new:user:session:requested', ->
    window.open API.getNewUserSessionPath(), '_self'
    
  App.reqres.setHandler 'new:user:session:path', ->
    API.getNewUserSessionPath()