@Artoo.module 'UserManagementUsersApp.EditRole', (EditRole, App, Backbone, Marionette, $, _) ->
  
  class EditRole.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'Edit Role'
    
    schema: ->
      [
        legend:   'Edit Role'
        hasHints: false
        
        fields: [
          name:    'auto_role'
          label:   'Auto Detect'
          type:    'radio_buttons'
          options: [{ id: true, name: 'Yes' }, { id: false, name: 'No' }]
        ,
          name:    'role_id'
          label:   'Role'
          tagName: 'select'
          options: App.entities.roles
          dependencies:
            auto_role:  value: 'false'
        ]
      ]