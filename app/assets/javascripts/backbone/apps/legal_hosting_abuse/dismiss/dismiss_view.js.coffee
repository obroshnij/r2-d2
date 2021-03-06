@Artoo.module 'LegalHostingAbuseApp.Dismiss', (Dismiss, App, Backbone, Marionette, $, _) ->
  
  class Dismiss.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'Dismiss Hosting Abuse'
    
    schema: ->
      [
        legend:   'Dismiss Hosting Abuse'
        hasHints: false
        
        fields: [
          name:    'status'
          type:    'hidden'
          value:   '_dismissed'
        ,
          name:    'updated_by_id'
          type:    'hidden'
          default: App.request('get:current:user').id
        ,
          name:    'comment'
          label:   'Reason'
          tagName: 'textarea'
        ]
      ]