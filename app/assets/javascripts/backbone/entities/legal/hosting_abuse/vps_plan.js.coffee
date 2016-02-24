@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.VpsPlan extends App.Entities.Model
  
  
  class Entities.HostingAbuse.VpsPlansCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.VpsPlan
  
   
  API =
    
    newVpsPlansCollection: (attrs = {}) ->
      new Entities.HostingAbuse.VpsPlansCollection attrs
  
      
  App.reqres.setHandler 'legal:hosting:abuse:vps:plan:entities', ->
    API.newVpsPlansCollection App.entities.legal.hosting_abuse.vps_plan