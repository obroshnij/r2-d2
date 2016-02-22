@Artoo.module 'UserManagementRolesApp.EditGroups', (EditGroups, App, Backbone, Marionette, $, _) ->
  
  class EditGroups.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'Edit Groups'
    
    schema: ->
      [
        legend:   'Edit Groups'
        hasHints: false
        
        fields: [
          name:    'group_ids'
          label:   'NC Directory Groups'
          type:    'collection_check_boxes'
          options: App.entities.directory_groups
        ]
      ]