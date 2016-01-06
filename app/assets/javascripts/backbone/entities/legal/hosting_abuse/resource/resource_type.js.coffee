@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Resource.ResourceType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Resource.ResourceTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.ResourceType
  
  
  API =
    
    newResourceTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.ResourceTypesCollection attrs
  
  
  App.reqres.setHandler 'legal:hosting:abuse:resource:type:entities', ->
    API.newResourceTypesCollection App.entities.legal.hosting_abuse.resource.type