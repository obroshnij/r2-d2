@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ResellerPackage extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ResellerPackages extends App.Entities.Collection
    model: Entities.HostingAbuse.ResellerPackage
  
   
  API =
    
    newResellerPackages: (params = {}) ->
      new Entities.HostingAbuse.ResellerPackages params
  
  
  App.reqres.setHandler 'set:hosting:abuse:reseller:package:entities', (params) ->
    App.entities.hostingAbuse.resellerPackages = API.newResellerPackages params
    
  App.reqres.setHandler 'hosting:abuse:reseller:package:entities', ->
    App.entities.hostingAbuse.resellerPackages