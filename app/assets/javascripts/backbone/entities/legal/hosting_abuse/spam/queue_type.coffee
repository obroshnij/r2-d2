@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Spam.QueueType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Spam.QueueTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Spam.QueueType
  
  
  API =
    
    newQueueTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Spam.QueueTypesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:spam:queue:type:entities', ->
    API.newQueueTypesCollection App.entities.legal.hosting_abuse.spam.queue_type