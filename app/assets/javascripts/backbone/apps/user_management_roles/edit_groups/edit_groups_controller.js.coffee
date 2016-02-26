@Artoo.module 'UserManagementRolesApp.EditGroups', (EditGroups, App, Backbone, Marionette, $, _) ->
  
  class EditGroups.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { role } = options
      
      editGroupsView = @getEditGroupsView role
      
      form = App.request 'form:component', editGroupsView,
        proxy:           'modal'
        model:           role
        focusFirstInput: false
        onCancel:        => @region.empty()
        onSuccess:       => @region.empty()
      
      @show form
          
    getEditGroupsView: (role) ->
      schema = new EditGroups.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  role