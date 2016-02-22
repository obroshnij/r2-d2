@Artoo.module 'UserManagementRolesApp.EditPermissions', (EditPermissions, App, Backbone, Marionette, $, _) ->
  
  class EditPermissions.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      role = App.request 'role:entity', options.id
      
      @layout = @getLayoutView role
      
      @show @layout, loading: true
      
    getLayoutView: (role) ->
      new EditPermissions.Layout
        model: role