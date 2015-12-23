@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Impact extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Impacts extends App.Entities.Collection
    model: Entities.HostingAbuse.Impact
  
   
  API =
    
    newImpacts: (params = {}) ->
      new Entities.HostingAbuse.Impacts params
  
  
  App.reqres.setHandler 'set:hosting:abuse:resource:impact:entities', (params) ->
    App.entities.hostingAbuse.impacts = API.newImpacts params
    
  App.reqres.setHandler 'hosting:abuse:resource:impact:entities', ->
    App.entities.hostingAbuse.impacts