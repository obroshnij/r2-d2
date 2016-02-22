@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Role extends App.Entities.Model
    urlRoot: -> Routes.roles_path()
  
  
  class Entities.RolesCollection extends App.Entities.Collection
    model: Entities.Role
    
    url: -> Routes.roles_path()
    
    
  API =
    
    getRolesCollection: ->
      roles = new App.Entities.RolesCollection
      roles.fetch()
      roles
      
    getRole: (id) ->
      role = new App.Entities.Role id: id
      role.fetch()
      role
      
  
  App.reqres.setHandler 'role:entities', ->
    API.getRolesCollection()
    
  App.reqres.setHandler 'role:entity', (id) ->
    API.getRole id