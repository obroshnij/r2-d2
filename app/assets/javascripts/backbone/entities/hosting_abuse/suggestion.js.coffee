@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Suggestion extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Suggestions extends App.Entities.Collection
    model: Entities.HostingAbuse.Suggestion
  
   
  API =
    
    newSuggestions: (params = {}) ->
      new Entities.HostingAbuse.Suggestions params
  
  
  App.reqres.setHandler 'set:hosting:abuse:suggestion:entities', (params) ->
    App.entities.hostingAbuse.suggestions = API.newSuggestions params
    
  App.reqres.setHandler 'hosting:abuse:suggestion:entities', ->
    App.entities.hostingAbuse.suggestions