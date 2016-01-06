@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Resource.Upgrade extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Resource.UpgradesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.Upgrade
  
   
  API =
    
    newUpgradesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.UpgradesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:resource:upgrade:entities', ->
    API.newUpgradesCollection App.entities.legal.hosting_abuse.resource.upgrade