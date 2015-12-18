@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Type extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Types extends App.Entities.Collection
    model: Entities.HostingAbuse.Type
  
   
  API =
    
    newAbuseTypes: (params = {}) ->
      new Entities.HostingAbuse.Types params
  
  
  App.reqres.setHandler 'set:hosting:abuse:type:entities', (params) ->
    App.entities.hostingAbuse.types = API.newAbuseTypes params
    
  App.reqres.setHandler 'hosting:abuse:type:entities', ->
    App.entities.hostingAbuse.types