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
          name:    'ticket_id'
          label:   'Ticket ID'
        ,
          name:    'legal_comments'
          label:   'Comments'
          tagName: 'textarea'
        ]
      ]