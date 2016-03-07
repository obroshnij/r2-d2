@Artoo.module 'UserManagementRolesApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'New Role'
    
    schema: ->
      [
        legend:   'New Role'
        hasHints: false
        
        fields: [
          name:    'name'
          label:   'Name'
        ]
      ]