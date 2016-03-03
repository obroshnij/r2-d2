@Artoo.module 'UserManagementRolesApp.EditGroups', (EditGroups, App, Backbone, Marionette, $, _) ->
  
  class EditGroups.Schema extends Marionette.Object
    
    modal:
      size:  'small'
      title: 'Edit Groups'
    
    schema: ->
      [
        legend:   'Edit Groups'
        hasHints: false
        
        fields: [
          name:    'group_ids'
          label:   'NC Directory Groups'
          tagName: 'select'
          type:    'select2_multi'
          options: App.entities.directory_groups
        ]
      ]