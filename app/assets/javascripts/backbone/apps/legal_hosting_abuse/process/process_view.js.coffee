@Artoo.module 'LegalHostingAbuseApp.Process', (Process, App, Backbone, Marionette, $, _) ->
  
  class Process.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'Process Hosting Abuse'
    
    schema: ->
      [
        legend:   'Process Hosting Abuse'
        hasHints: false
        
        fields: [
          name:    'status'
          type:    'hidden'
          value:   'processed'
        ,
          name:    'processed_by_id'
          type:    'hidden'
          default: App.request('get:current:user').id
        ,
          name:    'ticket_id'
          label:   'Ticket ID'
        ,
          name:    'legal_comments'
          label:   'Comments'
          tagName: 'textarea'
        ]
      ]