@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Suggestion extends App.Entities.Model
  
  
  class Entities.HostingAbuse.SuggestionsCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Suggestion
  
   
  API =
    
    newSuggestionsCollection: (attrs = {}) ->
      new Entities.HostingAbuse.SuggestionsCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:suggestion:entities', ->
    API.newSuggestionsCollection App.entities.legal.hosting_abuse.suggestion