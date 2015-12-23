@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ResourceAbuseType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ResourceAbuseTypes extends App.Entities.Collection
    model: Entities.HostingAbuse.ResourceAbuseType
  
  
  API =
    
    newResourceAbuseTypes: (params = {}) ->
      new Entities.HostingAbuse.ResourceAbuseTypes params
  
  
  App.reqres.setHandler 'set:hosting:abuse:resource:abuse:type:entities', (params) ->
    App.entities.hostingAbuse.resourceAbuseTypes = API.newResourceAbuseTypes params
    
  App.reqres.setHandler 'hosting:abuse:resource:abuse:type:entities', ->
    App.entities.hostingAbuse.resourceAbuseTypes