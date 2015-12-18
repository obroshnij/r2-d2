@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Service extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Services extends App.Entities.Collection
    model: Entities.HostingAbuse.Service
  
  
  API =
    
    newServices: (params = {}) ->
      new Entities.HostingAbuse.Services params
  
  
  App.reqres.setHandler 'set:hosting:abuse:service:entities', (params) ->
    App.entities.hostingAbuse.services = API.newServices params
    
  App.reqres.setHandler 'hosting:abuse:service:entities', ->
    App.entities.hostingAbuse.services