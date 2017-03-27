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
          name:    'processed_by_id'
          type:    'hidden'
          default: App.request('get:current:user').id
        ,
          name:    'verification_ticket_id'
          label:   'Ticket ID'
        ]
      ]
