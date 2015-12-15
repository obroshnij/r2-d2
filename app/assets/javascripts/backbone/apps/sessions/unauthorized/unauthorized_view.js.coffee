@Artoo.module "SessionsApp.Unauthorized", (Unauthorized, App, Backbone, Marionette, $, _) ->
  
  class Unauthorized.View extends App.Views.ItemView
    template: 'sessions/unauthorized/unauthorized'
    
    serializeData: ->
      newSessionPath: App.request 'new:user:session:path'