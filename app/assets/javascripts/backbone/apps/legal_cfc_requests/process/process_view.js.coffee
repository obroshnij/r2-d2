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
          name:     'request_type'
          type:     'hidden'
        ,
          name:     'processCommentRequired'
          type:     'hidden'
        ,
          name:     'frauded'
          label:    'Fraud?'
          type:     'radio_buttons'
          options: [
            { id: 'false', name: 'No' },
            { id: 'true',  name: 'Yes' }
          ]
          default: 'false'
          dependencies:
            request_type: value: ['check_for_fraud']
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
          callback: (fieldValues) ->
            _.defer =>
              if fieldValues.request_type is 'find_relations'
                @trigger('disable:options', 'unknown_relations')
              else
                @trigger('enable:options', 'unknown_relations')
        ]
      ,
        legend: 'Related Accounts'
        nested: true
        name:   'relations'
        hint:   " "

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
            'relations.relation_type_ids': value: ['other']
        ,
          name:    'certainty'
          label:   'Certainty (%)'
          type:    'number'
          dependencies:
            request_type: value: ['find_relations']
        ]
      ,
        name: 'comments'

        fields: [
          name:    'process_comments'
          label:   'Additional Comments'
          tagName: 'textarea'
          hint:    'Anything you would like to add (not required)'
        ,
          name:    'log_comments'
          label:   'Edit Reason'
          tagName: 'textarea'
          hint:    'Why is it necessary to edit the request?'
          dependencies:
            processCommentRequired: value: ['true']
        ]
      ]
