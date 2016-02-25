@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Spam.PeQueueType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Spam.PeQueueTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Spam.PeQueueType
  
  
  API =
    
    newPeQueueTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Spam.PeQueueTypesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:spam:pe:queue:type:entities', ->
    API.newPeQueueTypesCollection App.entities.legal.hosting_abuse.spam.pe_queue_type