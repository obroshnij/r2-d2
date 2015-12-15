@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.User extends App.Entities.Model
  
  class Entities.Users extends App.Entities.Collection
    model: Entities.User
    
  API =
    
    setCurrentUser: (currentUser) ->
      new Entities.User currentUser
  
  App.reqres.setHandler 'set:current:user', (currentUser) ->
    API.setCurrentUser currentUser if currentUser