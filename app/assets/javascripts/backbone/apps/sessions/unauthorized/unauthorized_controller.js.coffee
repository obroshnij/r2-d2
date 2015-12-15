@Artoo.module "SessionsApp.Unauthorized", (Unauthorized, App, Backbone, Marionette, $, _) ->
  
  class Unauthorized.Controller extends App.Controllers.Application
    
    initialize: ->
      unauthorizedView = @getUnauthorizedView()
      @show unauthorizedView
      
    getUnauthorizedView: ->
      new Unauthorized.View