@Artoo.module 'UserManagementRolesApp.EditPermissions', (EditPermissions, App, Backbone, Marionette, $, _) ->
  
  class EditPermissions.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      role      = App.request 'role:entity', options.id
      resources = App.request 'ability:resource:entities'
      
      @layout = @getLayoutView role
      
      @listenTo @layout, 'show', =>
        @formRegion role, resources
      
      @show @layout, loading: true
      
    formRegion: (role, resources) ->
      resourcesView = @getResourcesView resources
      
      form = App.request 'form:component', resourcesView,
        model:           role
        focusFirstInput: false
        deserialize:     true
        onSuccess:       -> App.vent.trigger 'roles:permissions:updated', role
        onCancel:        -> App.vent.trigger 'roles:permissions:cancelled'
      
      @show form, region: @layout.formRegion
      
    getResourcesView: (resources) ->
      new EditPermissions.Resources
        collection: resources
      
    getLayoutView: (role) ->
      new EditPermissions.Layout
        model: role