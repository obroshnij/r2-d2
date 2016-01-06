@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Resource.ActivityType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Resource.ActivityTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.ActivityType
  
  
  API =
    
    newActivityTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.ActivityTypesCollection attrs
  
  
  App.reqres.setHandler 'legal:hosting:abuse:resource:activity:type:entities', ->
    API.newActivityTypesCollection App.entities.legal.hosting_abuse.resource.activity_type