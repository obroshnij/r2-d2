@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.AbuseType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.AbuseTypes extends App.Entities.Collection
    model: Entities.HostingAbuse.AbuseType
  
   
  API =
    
    newAbuseAbuseTypes: (params = {}) ->
      new Entities.HostingAbuse.AbuseTypes params
  
  
  App.reqres.setHandler 'set:hosting:abuse:type:entities', (params) ->
    App.entities.hostingAbuse.types = API.newAbuseAbuseTypes params
    
  App.reqres.setHandler 'hosting:abuse:type:entities', ->
    App.entities.hostingAbuse.types