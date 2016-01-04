@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.DdosBlockType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.DdosBlockTypes extends App.Entities.Collection
    model: Entities.HostingAbuse.DdosBlockType
  
   
  API =
    
    newDdosBlockTypes: (params = {}) ->
      new Entities.HostingAbuse.DdosBlockTypes params
  
  
  App.reqres.setHandler 'set:hosting:abuse:ddos:block:type:entities', (params) ->
    App.entities.hostingAbuse.ddosBlockTypes = API.newDdosBlockTypes params
    
  App.reqres.setHandler 'hosting:abuse:ddos:block:type:entities', ->
    App.entities.hostingAbuse.ddosBlockTypes