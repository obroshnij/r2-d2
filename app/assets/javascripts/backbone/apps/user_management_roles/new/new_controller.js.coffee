@Artoo.module 'UserManagementRolesApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      role = App.request 'new:role:entity'
      
      newRoleView = @getNewRoleView role
      
      form = App.request 'form:component', newRoleView,
        proxy:           'modal'
        model:           role
        onCancel:        => @region.empty()
        onSuccess:       =>
          @region.empty()
          App.vent.trigger 'new:role:created'
        
      @show form
      
    getNewRoleView: (role) ->
      schema = new New.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  role