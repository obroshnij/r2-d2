@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  _.extend App,
  
    bootstrap: (options) ->
      @environment = options.environment
      @currentUser = App.request 'init:current:user', options.currentUser
      
      @entities = {}
      @entities.hostingAbuse = {}
      
      App.request 'set:hosting:abuse:service:entities', options.hostingAbuseServices
      App.request 'set:hosting:abuse:type:entities',    options.hostingAbuseTypes