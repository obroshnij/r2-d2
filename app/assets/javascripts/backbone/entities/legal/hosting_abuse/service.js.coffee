@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Service extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ServicesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Service
  
  
  API =
    
    newServicesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.ServicesCollection attrs
      
  
  App.reqres.setHandler 'legal:hosting:abuse:service:entities', ->
    API.newServicesCollection App.entities.legal.hosting_abuse.service