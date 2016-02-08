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
          name:    'status'
          type:    'hidden'
          value:   'dismissed'
        ,
          name:    'processed_by_id'
          type:    'hidden'
          default: App.request('get:current:user').id
        ,
          name:    'legal_comments'
          label:   'Comments'
          tagName: 'textarea'
        ]
      ]