@Artoo.module 'UserManagementRolesApp.EditPermissions', (EditPermissions, App, Backbone, Marionette, $, _) ->
  
  class EditPermissions.Layout extends App.Views.LayoutView
    template: 'user_management_roles/edit_permissions/layout'
    
    regions:
      resourcesRegion: '#resources-region'
      
  
  class EditPermissions.Resource extends App.Views.ItemView
    template: 'user_management_roles/edit_permissions/resource'
    
    tagName: 'li'
  
  
  class EditPermissions.Resources extends App.Views.CompositeView
    template:  'user_management_roles/edit_permissions/resources'
    
    childView:          EditPermissions.Resource
    childViewContainer: 'ul'