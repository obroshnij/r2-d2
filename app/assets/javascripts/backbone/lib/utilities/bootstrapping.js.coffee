@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  _.extend App,
  
    bootstrap: (options) ->
      @environment = options.environment
      @currentUser = App.request 'init:current:user', options.currentUser
      
      @entities = {}
      @entities.hostingAbuse = {}
      
      App.request 'set:hosting:abuse:service:entities',               options.hostingAbuseServices
      App.request 'set:hosting:abuse:type:entities',                  options.hostingAbuseTypes
      App.request 'set:hosting:abuse:shared:package:entities',        options.hostingAbuseSharedPackages
      App.request 'set:hosting:abuse:reseller:package:entities',      options.hostingAbuseResellerPackages
      App.request 'set:hosting:abuse:management:type:entities',       options.hostingAbuseManagementTypes
      App.request 'set:hosting:abuse:spam:detection:method:entities', options.hostingAbuseSpamDetectionMethods