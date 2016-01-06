@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  _.extend App,
  
    bootstrap: (options) ->
      @environment = options.environment
      @entities    = options.entities
      @currentUser = App.request 'init:current:user', options.current_user