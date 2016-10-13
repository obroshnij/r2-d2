@Artoo.module 'DomainsCompensationApp.Check', (Check, App, Backbone, Marionette, $, _) ->

  class Check.Schema extends Marionette.Object

    modal:
      title: 'Compensation QA Check'

    schema: ->
      [
        legend:   'QA Check'
        hasHints: false

        fields: [
          name:     'status'
          type:     'hidden'
          value:  '_checked'
        ,
          name:    'checked_by_id'
          type:    'hidden'
          default: App.request('get:current:user').id
        ,
          name:    'used_correctly'
          label:   'Status'
          type:    'radio_buttons'
          options: [{ id: 'true', name: 'Used Correctly' }, { id: 'false', name: 'Used Incorrectly' }]
          default: 'true'
        ,
          name:    'delivered'
          label:   'Delivered to CS'
          type:    'radio_buttons'
          options: [{ id: 'true', name: 'Yes' }, { id: 'false', name: 'No' }]
          default: 'true'
          dependencies:
            'used_correctly': value: 'false'
        ,
          name:    'qa_comments'
          label:   'Comments'
          tagName: 'textarea'
        ]
      ]
