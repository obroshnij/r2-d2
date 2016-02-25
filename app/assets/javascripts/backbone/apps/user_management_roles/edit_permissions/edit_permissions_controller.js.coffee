@Artoo.module 'UserManagementRolesApp.EditPermissions', (EditPermissions, App, Backbone, Marionette, $, _) ->
  
  class EditPermissions.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      role      = App.request 'role:entity', options.id
      resources = App.request 'ability:resource:entities'
      
      @layout = @getLayoutView role
      
      @listenTo @layout, 'show', =>
        @resourcesRegion resources
      
      @show @layout, loading: true
      
    resourcesRegion: (resources) ->
      resourcesView = @getResourcesView resources
      
      @show resourcesView, region: @layout.resourcesRegion
      
    getResourcesView: (resources) ->
      new EditPermissions.Resources
        collection: resources
      
    getLayoutView: (role) ->
      new EditPermissions.Layout
        model: role