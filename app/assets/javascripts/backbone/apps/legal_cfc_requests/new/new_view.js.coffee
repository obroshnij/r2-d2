@Artoo.module 'LegalCfcRequestsApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'legal_cfc_requests/new/layout'

    regions:
      formRegion: '#form-region'


  class New.FormSchema extends Marionette.Object

    schema: ->
      [
        legend: 'New CFC Request'
        id:     'new-cfc-request'

        fields: [
          name:    'submitted_by_id'
          type:    'hidden'
          default: App.request('get:current:user').id
        ,
          name:    'editCommentRequired'
          type:    'hidden'
        ,
          name:    'canSelectLegalRequest'
          type:    'hidden'
          value:   App.ability.can('request_relations_for_legal', 'Legal::CfcRequest')
        ,
          name:    'requiresAgreedWith'
          type:    'hidden'
          value:   not App.ability.can('request_relations_without_agreement', 'Legal::CfcRequest')
        ,
          name:    'nc_username'
          label:   'Username'
          hint:    'Namecheap account username'
        ,
          name:    'signup_date'
          label:   'Signup Date'
          type:    'date_range_picker'
          dateRangePickerOptions:
            singleDatePicker: true
        ,
          name:    'request_type'
          label:   'Request Type'
          type:    'radio_buttons'
          options: [
            { name: 'Check for Fraud', id: 'check_for_fraud' },
            { name: 'Find Relations',  id: 'find_relations' }
          ]
          default: 'check_for_fraud'
        ,
          name:    'investigate_unless_fraud'
          label:   'Investigate unless Fraud'
          type:    'radio_buttons'
          options: [
            { name: 'Yes', id: 'true' },
            { name: 'No',  id: 'false' }
          ]
          default: 'false'
          hint:    'Initiate internal investigation if user is not frauded'
          dependencies:
            request_type: value: ['check_for_fraud']
        ,
          name:    'find_relations_reason'
          label:   'Reason'
          type:    'collection_radio_buttons'
          options: [
            { name: 'Internal Investigation', id: 'internal_investigation' },
            { name: 'Legal Request',          id: 'legal_request' }
          ]
          default: 'internal_investigation'
          dependencies:
            request_type: value: ['find_relations']
          callback: (fieldValues) ->
            _.defer =>
              if fieldValues.canSelectLegalRequest
                @trigger('enable:options', 'legal_request')
              else
                @trigger('disable:options', 'legal_request')
        ,
          name:    'investigation_approved_by_id'
          label:   'Agreed with'
          tagName: 'select'
          options: App.entities.legal.cfc_requests.may_approve_relation_requests
          dependencies: [
            request_type:          value: ['find_relations']
            find_relations_reason: value: ['internal_investigation']
            requiresAgreedWith:    value: ['true']
          ,
            request_type:             value: ['check_for_fraud']
            investigate_unless_fraud: value: ['true']
            requiresAgreedWith:       value: ['true']
          ]
        ,
          name:    'certainty_threshold'
          label:   'Required Certainty'
          hint:    'Relations certainty percent to look for (greater than or equal to)'
          dependencies: [
            request_type: value: ['find_relations']
          ,
            request_type:             value: ['check_for_fraud']
            investigate_unless_fraud: value: ['true']
          ]
          callback: (fieldValues) ->
            _.defer =>
              if fieldValues.request_type is 'find_relations' and fieldValues.find_relations_reason is 'legal_request'
                @trigger('enable:input')
              else
                @trigger('disable:input', '60')
        ,
          name:    'reference'
          label:   'Reference'
          hint:    'Ticket ID or email subject'
        ,
          name:    'service_type'
          label:   'Service Type'
          type:    'collection_radio_buttons'
          options: [
            { name: 'Domain',        id: 'domain' },
            { name: 'Hosting',       id: 'hosting' },
            { name: 'Private Email', id: 'private_email' }
          ]
          default: 'domain'
        ,
          name:    'domain_name'
          label:   'Domain Name'
          dependencies:
            service_type: value: ['domain']
        ,
          name:    'service_id'
          label:   'Service ID'
          dependencies:
            service_type: value: ['hosting']
        ,
          name:    'pe_subscription'
          label:   'Host Name'
          dependencies:
            service_type: value: ['private_email']
        ,
          name:    'abuse_type'
          label:   'Abuse Type'
          type:    'collection_radio_buttons'
          options: [
            { name: 'Phishing',        id: 'phishing' },
            { name: 'Scam',            id: 'scam' },
            { name: 'Deliberate Spam', id: 'deliberate_spam' },
            { name: 'Other',           id: 'other_abuse' }
          ]
          default: 'phishing'
        ,
          name:    'other_description'
          label:   'Description'
          tagName: 'textarea'
          dependencies:
            abuse_type: value: ['other_abuse']
        ,
          name:    'service_status'
          label:   'Current Service Status'
          type:    'collection_radio_buttons'
          options: [
            { name: 'Active',    id: 'active' },
            { name: 'Suspended', id: 'suspended' },
            { name: 'Cancelled', id: 'cancelled' }
          ]
          default: 'active'
        ,
          name:    'service_status_reference'
          label:   'Reference'
          dependencies:
            service_status: value: ['suspended', 'cancelled']
          hint: 'Ticket or cancel request ID'
        ,
          name:    'comments'
          label:   'Additional Comments'
          tagName: 'textarea'
          hint:    'Anything you would like to add (not required)'
        ,
          name:    'log_comments'
          label:   'Edit Reason'
          tagName: 'textarea'
          hint:    'Why is it necessary to edit the request?'
          dependencies:
            editCommentRequired: value: ['true']
        ]
      ]
