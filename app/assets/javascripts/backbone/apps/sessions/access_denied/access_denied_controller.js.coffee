@Artoo.module "SessionsApp.AccessDenied", (AccessDenied, App, Backbone, Marionette, $, _) ->
  
  class AccessDenied.Controller extends App.Controllers.Application
    
    initialize: ->
      view = @getView()
      @show view
      
    getView: ->
      new AccessDenied.View