@Artoo.module 'LegalRblsListApp.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  
  class Edit.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'Edit RBL'
      
    schema: ->
      [
        legend:   'Edit RBL'
        hasHints: false
        
        fields: [
          name:    'rbl_status_id'
          label:   'Status'
          tagName: 'select'
          options: @getStatuses()
        ,
          name:    'url'
          label:   'URL'
        ,
          name:    'comment'
          label:   'Comment'
          tagName: 'textarea'
        ]
      ]
      
    getStatuses: ->
      App.entities.legal.rbl_status