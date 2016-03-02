@Artoo.module 'LegalHostingAbuseApp.Unprocess', (Unprocess, App, Backbone, Marionette, $, _) ->
  
  class Unprocess.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'Unprocess Hosting Abuse'
    
    schema: ->
      [
        legend:   'Unprocess Hosting Abuse'
        hasHints: false
        
        fields: [
          name:    'status'
          type:    'hidden'
          value:   '_unprocessed'
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