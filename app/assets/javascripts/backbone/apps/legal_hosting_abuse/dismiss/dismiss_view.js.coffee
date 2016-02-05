@Artoo.module 'LegalHostingAbuseApp.Dismiss', (Dismiss, App, Backbone, Marionette, $, _) ->
  
  class Dismiss.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'Process Hosting Abuse'
    
    schema: ->
      [
        legend:   'Dismiss Hosting Abuse'
        hasHints: false
        
        fields: [
          name:    'legal_comments'
          label:   'Comments'
          tagName: 'textarea'
        ]
      ]