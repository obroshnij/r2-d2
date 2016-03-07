@Artoo.module 'UserManagementRolesApp.EditPermissions', (EditPermissions, App, Backbone, Marionette, $, _) ->
  
  class EditPermissions.Layout extends App.Views.LayoutView
    template: 'user_management_roles/edit_permissions/layout'
    
    regions:
      formRegion: '#form-region'
      
  
  class EditPermissions.Resource extends App.Views.ItemView
    template: 'user_management_roles/edit_permissions/resource'
    
    tagName: 'fieldset'
  
  
  class EditPermissions.Resources extends App.Views.CollectionView
    childView:          EditPermissions.Resource
    
    className: 'permissions-form'