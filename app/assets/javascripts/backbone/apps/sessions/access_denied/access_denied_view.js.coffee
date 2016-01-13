@Artoo.module "SessionsApp.AccessDenied", (AccessDenied, App, Backbone, Marionette, $, _) ->
  
  class AccessDenied.View extends App.Views.ItemView
    template: 'sessions/access_denied/access_denied'