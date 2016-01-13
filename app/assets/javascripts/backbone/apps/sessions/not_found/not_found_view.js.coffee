@Artoo.module "SessionsApp.NotFound", (NotFound, App, Backbone, Marionette, $, _) ->
  
  class NotFound.View extends App.Views.ItemView
    template: 'sessions/not_found/not_found'