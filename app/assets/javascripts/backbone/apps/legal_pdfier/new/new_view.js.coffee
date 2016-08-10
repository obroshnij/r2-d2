@Artoo.module 'LegalPdfierApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Schema extends Marionette.Object

    modal:
      size:  'tiny'
      title: 'New PDF Report'

    schema: ->
      [
        legend:   'New PDF Report'
        hasHints: false

        fields: [
          name:    'username'
          label:   'Namecheap Username'
        ,
          name:     'created_by_id'
          type:     'hidden'
          default:  App.request('get:current:user').id
        ]
      ]
