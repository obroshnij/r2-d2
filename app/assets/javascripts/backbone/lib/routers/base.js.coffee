@Artoo.module 'Routers', (Routers, App, Backbone, Marionette, $, _) ->
  
  class Routers.Base extends Marionette.AppRouter
    
    constructor: (options = {}) ->
      _.defaults options,
        authRequired: true
      
      @authRequired = options.authRequired
      
      super
      
    before: (route, params) ->
      currentUser = App.request 'get:current:user'
      
      if @authRequired and !currentUser
        App.vent.trigger 'auth:required'
        return false
      
      true