@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.User extends App.Entities.Model
    urlRoot: -> Routes.users_path()
  
  
  class Entities.Users extends App.Entities.Collection
    model: Entities.User
    
    url: -> Routes.users_path()
  
  
  API =
    
    newUser: (attrs = {}) ->
      new Entities.User attrs
      
    getUsersCollection: ->
      users = new App.Entities.Users
      users.fetch()
      users
  
  
  App.reqres.setHandler 'init:current:user', (currentUser) ->
    API.newUser currentUser if currentUser
    
  App.reqres.setHandler 'user:entities', ->
    API.getUsersCollection()