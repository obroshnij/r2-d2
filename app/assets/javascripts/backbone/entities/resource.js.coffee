@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Resource extends App.Entities.Model
  
  
  class Entities.ResourcesCollection extends App.Entities.Collection
    model: Entities.Resource
    
    
  API =
    
    getResourcesCollection: ->
      new App.Entities.ResourcesCollection App.entities.ability_resources
  
  
  App.reqres.setHandler 'ability:resource:entities', ->
    API.getResourcesCollection()