@Artoo.module 'UserManagementUsersApp.EditRole', (EditRole, App, Backbone, Marionette, $, _) ->
  
  class EditRole.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { user } = options
      
      editRoleView = @getEditRoleView user
    
      form = App.request 'form:component', editRoleView,
        proxy:           'modal'
        model:           user
        focusFirstInput: false
        onCancel:        => @region.empty()
        onSuccess:       => @region.empty()
    
      @show form
        
    getEditRoleView: (user) ->
      schema = new EditRole.Schema
    
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  user