@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Ddos.BlockType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Ddos.BlockTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Ddos.BlockType
  
  
  API =
    
    newBlockTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Ddos.BlockTypesCollection attrs
  
  
  App.reqres.setHandler 'legal:hosting:abuse:ddos:block:type:entities', ->
    API.newBlockTypesCollection App.entities.legal.hosting_abuse.ddos.block_type