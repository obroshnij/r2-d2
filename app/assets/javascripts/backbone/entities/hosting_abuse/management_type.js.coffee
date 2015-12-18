@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ManagementType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ManagementTypes extends App.Entities.Collection
    model: Entities.HostingAbuse.ManagementType
  
  
  API =
    
    newManagementTypes: (params = {}) ->
      new Entities.HostingAbuse.ManagementTypes params
  
  
  App.reqres.setHandler 'set:hosting:abuse:management:type:entities', (params) ->
    App.entities.hostingAbuse.managementTypes = API.newManagementTypes params
    
  App.reqres.setHandler 'hosting:abuse:management:type:entities', ->
    App.entities.hostingAbuse.managementTypes