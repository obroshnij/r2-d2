@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Resource.Measure extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Resource.MeasuresCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.Measure
  
  
  API =
    
    newMeasuresCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.MeasuresCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:resource:measure:entities', ->
    API.newMeasuresCollection App.entities.legal.hosting_abuse.resource.measure