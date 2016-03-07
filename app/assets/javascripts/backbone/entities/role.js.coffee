@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Role extends App.Entities.Model
    urlRoot: -> Routes.roles_path()
    
    mutators:
      
      canBeDestroyed: ->
        return true unless @get('users_names')
        @get('users_names').length is 0
  
  
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
      
    newRole: (attrs = {}) ->
      new App.Entities.Role attrs
      
  
  App.reqres.setHandler 'role:entities', ->
    API.getRolesCollection()
    
  App.reqres.setHandler 'role:entity', (id) ->
    API.getRole id
    
  App.reqres.setHandler 'new:role:entity', (attrs = {}) ->
    API.newRole attrs