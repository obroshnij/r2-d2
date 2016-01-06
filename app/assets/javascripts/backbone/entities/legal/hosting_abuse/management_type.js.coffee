@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ManagementType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ManagementTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.ManagementType
  
  
  API =
    
    newManagementTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.ManagementTypesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:management:type:entities', ->
    API.newManagementTypesCollection App.entities.legal.hosting_abuse.management_type