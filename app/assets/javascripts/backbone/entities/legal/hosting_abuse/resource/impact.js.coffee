@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Resource.Impact extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Resource.ImpactsCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.Impact
  
   
  API =
    
    newImpactsCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.ImpactsCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:resource:impact:entities', ->
    API.newImpactsCollection App.entities.legal.hosting_abuse.resource.impact