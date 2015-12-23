@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Measure extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Measures extends App.Entities.Collection
    model: Entities.HostingAbuse.Measure
  
  
  API =
    
    newMeasures: (params = {}) ->
      new Entities.HostingAbuse.Measures params
  
  
  App.reqres.setHandler 'set:hosting:abuse:resource:measure:entities', (params) ->
    App.entities.hostingAbuse.measures = API.newMeasures params
    
  App.reqres.setHandler 'hosting:abuse:resource:measure:entities', ->
    App.entities.hostingAbuse.measures