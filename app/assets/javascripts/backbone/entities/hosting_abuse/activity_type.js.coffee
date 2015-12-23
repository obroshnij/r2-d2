@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ActivityType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ActivityTypes extends App.Entities.Collection
    model: Entities.HostingAbuse.ActivityType
  
  
  API =
    
    newActivityTypes: (params = {}) ->
      new Entities.HostingAbuse.ActivityTypes params
  
  
  App.reqres.setHandler 'set:hosting:abuse:resource:activity:type:entities', (params) ->
    App.entities.hostingAbuse.activityTypes = API.newActivityTypes params
    
  App.reqres.setHandler 'hosting:abuse:resource:activity:type:entities', ->
    App.entities.hostingAbuse.activityTypes