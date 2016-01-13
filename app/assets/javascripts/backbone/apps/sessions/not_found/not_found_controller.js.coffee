@Artoo.module "SessionsApp.NotFound", (NotFound, App, Backbone, Marionette, $, _) ->
  
  class NotFound.Controller extends App.Controllers.Application
    
    initialize: ->
      view = @getView()
      @show view
      
    getView: ->
      new NotFound.View