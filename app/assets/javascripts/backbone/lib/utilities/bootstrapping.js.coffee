@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  _.extend App,
  
    bootstrap: (options) ->
      @environment = options.environment
      @currentUser = App.request 'init:current:user', options.currentUser
      
      @entities = {}
      @entities.hostingAbuse = {}
      
      App.request 'set:hosting:abuse:service:entities',                     options.hostingAbuseServices
      App.request 'set:hosting:abuse:type:entities',                        options.hostingAbuseTypes
      App.request 'set:hosting:abuse:shared:package:entities',              options.hostingAbuseSharedPackages
      App.request 'set:hosting:abuse:reseller:package:entities',            options.hostingAbuseResellerPackages
      App.request 'set:hosting:abuse:management:type:entities',             options.hostingAbuseManagementTypes
      App.request 'set:hosting:abuse:suggestion:entities',                  options.hostingAbuseSuggestions
      App.request 'set:hosting:abuse:spam:detection:method:entities',       options.hostingAbuseSpamDetectionMethods
      App.request 'set:hosting:abuse:spam:reporting:party:entities',        options.hostingAbuseSpamReportingParties
      App.request 'set:hosting:abuse:resource:abuse:type:entities',         options.hostingAbuseResourceAbuseTypes
      App.request 'set:hosting:abuse:resource:activity:type:entities',      options.hostingAbuseResourceActivityTypes
      App.request 'set:hosting:abuse:resource:measure:entities',            options.hostingAbuseResourceMeasures
      App.request 'set:hosting:abuse:resource:type:entities',               options.hostingAbuseResourceTypes
      App.request 'set:hosting:abuse:resource:upgrade:suggestion:entities', options.hostingAbuseResourceUpgradeSuggestions
      App.request 'set:hosting:abuse:resource:impact:entities',             options.hostingAbuseResourceImpacts
      App.request 'set:hosting:abuse:ddos:block:type:entities',             options.hostingAbuseDdosBlockTypes