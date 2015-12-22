@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.SpamDetectionMethod extends App.Entities.Model
  
  
  class Entities.HostingAbuse.SpamDetectionMethods extends App.Entities.Collection
    model: Entities.HostingAbuse.SpamDetectionMethod
  
  
  API =
    
    newSpamDetectionMethods: (params = {}) ->
      new Entities.HostingAbuse.SpamDetectionMethods params
  
  
  App.reqres.setHandler 'set:hosting:abuse:spam:detection:method:entities', (params) ->
    App.entities.hostingAbuse.spamDetectionMethods = API.newSpamDetectionMethods params
    
  App.reqres.setHandler 'hosting:abuse:spam:detection:method:entities', ->
    App.entities.hostingAbuse.spamDetectionMethods