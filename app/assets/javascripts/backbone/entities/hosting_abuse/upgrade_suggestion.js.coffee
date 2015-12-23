@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.UpgradeSuggestion extends App.Entities.Model
  
  
  class Entities.HostingAbuse.UpgradeSuggestions extends App.Entities.Collection
    model: Entities.HostingAbuse.UpgradeSuggestion
  
   
  API =
    
    newUpgradeSuggestions: (params = {}) ->
      new Entities.HostingAbuse.UpgradeSuggestions params
  
  
  App.reqres.setHandler 'set:hosting:abuse:resource:upgrade:suggestion:entities', (params) ->
    App.entities.hostingAbuse.upgradeSuggestions = API.newUpgradeSuggestions params
    
  App.reqres.setHandler 'hosting:abuse:resource:upgrade:suggestion:entities', ->
    App.entities.hostingAbuse.upgradeSuggestions