@Artoo.module 'UserManagementRolesApp.EditPermissions', (EditPermissions, App, Backbone, Marionette, $, _) ->
  
  class EditPermissions.Layout extends App.Views.LayoutView
    template: 'user_management_roles/edit_permissions/layout'