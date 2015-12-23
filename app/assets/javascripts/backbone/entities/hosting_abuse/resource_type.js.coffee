@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ResourceType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ResourceTypes extends App.Entities.Collection
    model: Entities.HostingAbuse.ResourceType
  
   
  API =
    
    newAbuseResourceTypes: (params = {}) ->
      new Entities.HostingAbuse.ResourceTypes params
  
  
  App.reqres.setHandler 'set:hosting:abuse:resource:type:entities', (params) ->
    App.entities.hostingAbuse.resourceTypes = API.newAbuseResourceTypes params
    
  App.reqres.setHandler 'hosting:abuse:resource:type:entities', ->
    App.entities.hostingAbuse.resourceTypes