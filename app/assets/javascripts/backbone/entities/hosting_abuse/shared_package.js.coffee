@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.SharedPackage extends App.Entities.Model
  
  
  class Entities.HostingAbuse.SharedPackages extends App.Entities.Collection
    model: Entities.HostingAbuse.SharedPackage
  
   
  API =
    
    newSharedPackages: (params = {}) ->
      new Entities.HostingAbuse.SharedPackages params
  
  
  App.reqres.setHandler 'set:hosting:abuse:shared:package:entities', (params) ->
    App.entities.hostingAbuse.sharedPackages = API.newSharedPackages params
    
  App.reqres.setHandler 'hosting:abuse:shared:package:entities', ->
    App.entities.hostingAbuse.sharedPackages