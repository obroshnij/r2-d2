@Artoo.module 'LegalCfcRequestsApp.Verify', (Verify, App, Backbone, Marionette, $, _) ->

  class Verify.Schema extends Marionette.Object

    modal:
      size:  'tiny'
      title: 'Pending Verification'

    schema: ->
      [
        legend:   'Pending Verification'
        hasHints: false

        fields: [
          name:    'verified_by_id'
          type:    'hidden'
          default: App.request('get:current:user').id
        ,
          name:    'verifyCommentRequired'
          type:    'hidden'
        ,
          name:    'verification_ticket_id'
          label:   'Ticket ID'
        ,
          name:    'log_comments'
          label:   'Edit Reason'
          tagName: 'textarea'
          dependencies:
            verifyCommentRequired: value: ['true']
        ]
      ]
