@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.User extends App.Entities.Model
  
  
  class Entities.Users extends App.Entities.Collection
    model: Entities.User
  
  
  API =
    
    newUser: (attrs = {}) ->
      new Entities.User attrs
  
  
  App.reqres.setHandler 'init:current:user', (currentUser) ->
    API.newUser currentUser if currentUser