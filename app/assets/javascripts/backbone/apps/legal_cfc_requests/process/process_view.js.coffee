@Artoo.module 'LegalCfcRequestsApp.Process', (Process, App, Backbone, Marionette, $, _) ->

  class Process.Layout extends App.Views.LayoutView
    template: 'legal_cfc_requests/process/layout'

    regions:
      formRegion: '#form-region'


  class Process.FormSchema extends Marionette.Object

    schema: ->
      [
        legend: 'Process CFC Request'
        id:     'process-cfc-request'

        fields: [
          name:     'processed_by_id'
          type:     'hidden'
          default:  App.request('get:current:user').id
        ,
          name:     'frauded'
          label:    'Frauded?'
          type:     'radio_buttons'
          options: [
            { id: 'false', name: 'No' },
            { id: 'true',  name: 'Yes' }
          ]
          default: 'false'
        ,
          name:     'relations_status'
          label:    'Related Accounts'
          type:     'radio_buttons'
          options: [
            { id: 'unknown_relations', name: 'Not Searched' },
            { id: 'has_relations',     name: 'Found' },
            { id: 'has_no_relations',  name: 'Not Found' }
          ]
          default: 'unknown_relations'
        ]
      ,
        legend: 'Related Accounts'
        nested: true
        name:   'relations'

        dependencies:
          relations_status: value: ['has_relations']

        fields: [
          name:    'id'
          type:    'hidden'
        ,
          name:    'username'
          label:   'Username(s)'
          tagName: 'textarea'
        ,
          name:    'relation_type_ids'
          label:   'Related by'
          tagName: 'select'
          type:    'select2_multi'
          options: App.entities.legal.user_relation_types
        ,
          name:    'comment'
          label:   'Comment'
          tagName: 'textarea'
          dependencies:
            relation_type_ids: value: ['other']
        ,
          name:    'certainty'
          label:   'Certainty (%)'
          type:    'number'
        ]
      ]
