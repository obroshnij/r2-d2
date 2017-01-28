@Artoo.module 'LegalHostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'legal_hosting_abuse/new/layout'

    regions:
      formRegion: '#form-region'


  class New.FormSchema extends Marionette.Object

    schema: ->
      [
        legend:     'Client Details'
        id:         'client-details'

        fields: [
          name:     'reported_by_id'
          type:     'hidden'
          default:  App.request('get:current:user').id
        ,
          name:     'updated_by_id'
          type:     'hidden'
          value:    App.request('get:current:user').id
        ,
          name:     'status'
          type:     'hidden'
          value:    '_new'
        ,
          name:     'editCommentRequired'
          type:     'hidden'
        ,
          name:     'service_id'
          label:    'Service'
          tagName:  'select'
          options:  @getServices()
          hint:     'Abused service'
        ,
          name:     'type_id'
          label:    'Abuse Type'
          tagName:  'select'
          options:  @getAbuseTypes()
          hint:     'Type of the issue'
        ,
          name:     'server_name'
          label:    'Server Name'
          hint:     'E.g. server78.web-hosting.com, host7.registrar-servers.com, etc.'
          dependencies:
            service_id:      value: [1, 2, 3, 4]
        ,
          name:     'efwd_server_name'
          label:    'Server Name'
          hint:     'E.g. eforward3d.registrar-servers.com'
          dependencies:
            service_id:     value: 6
        ,
          name:     'shared_plan_id'
          label:    'Package'
          tagName:  'select'
          options:  @getSharedPlans()
          hint:     "Email Only (e.g. mailserver3.web-hosting.com) can only be abused by Email Abuse / Spam\nBusiness Expert can't abuse Disk-Space (150 GB allowed)"
          dependencies:
            service_id:      value: 1
        ,
          name:     'reseller_plan_id'
          label:    'Package'
          tagName:  'select'
          options:  @getResellerPlans()
          dependencies:
            service_id:      value: 2
        ,
          name:     'vps_plan_id'
          label:    'Package'
          tagName:  'select'
          options:  @getVpsPlans()
          dependencies:
            service_id:      value: 3
        ,
          name:     'username'
          label:    'Username'
          hint:     'cPanel username (OWNER for resellers)'
          dependencies: [
            service_id:         value: [1, 2]
          ,
            service_id:         value: [3, 4]
            management_type_id: value: 3
          ]
        ,
          name:     'resold_username'
          label:    'Resold Username'
          hint:     'Leave blank if it equals the OWNER'
          dependencies:
            service_id:      value: 2
        ,
          name:     'subscription_name'
          label:    'Domain Name'
          hint:     'Domain or host name associated with the subscription'
          dependencies:
            service_id:      value: [5, 6]
        ,
          name:     'server_rack_label'
          label:    'Server Rack Label'
          hint:     'E.g. NC-PH-0731-26'
          dependencies:
            service_id:      value: 4
        ,
          name:     'management_type_id'
          label:    'Type of Management'
          tagName:  'select'
          options:  @getManagementTypes()
          dependencies:
            service_id:      value: [3, 4]
        ]
      ,
        legend:     'Email Abuse / Spam'
        id:         'spam'
        dependencies:
          type_id:     value: 1
          service_id:  value: [1, 2, 3, 4, 6]

        fields: [
          name:     'spam[detection_method_id]'
          label:    'Detected by'
          type:     'collection_radio_buttons'
          options:  @getSpamDetectionMethods()
          default:  1
          hint:     'How was the issue detected?'
          callback: (fieldValues) ->
            if fieldValues.service_id?.toString() is '6' then @trigger('disable:options', 2) else @trigger('enable:options', 2)
        ,
          name:     'spam[queue_type_ids]'
          label:    'Queue Type'
          type:     'collection_check_boxes'
          options:  @getSpamQueueTypes()
          dependencies:
            'spam[detection_method_id]':  value: 1
          callback: (fieldValues) ->
            if fieldValues.service_id?.toString() is '6' then @trigger('disable:options', 1) else @trigger('enable:options', 1)
        ,
          name:     'spam[outgoing_emails_queue]'
          label:    'Outgoing Emails Queue'
          hint:     'Amount of emails queued on the server'
          dependencies:
            'spam[detection_method_id]':  value: 1
            'spam[queue_type_ids]':       value: [1, 2]
        ,
          name:     'spam[recepients_per_email]'
          label:    'Recepients per Email'
          hint:     'Approximate amount of recepients per message if necessary'
          dependencies:
            'spam[detection_method_id]':  value: 1
            'spam[queue_type_ids]':       value: [1, 2]
        ,
          name:     'spam[bounced_emails_queue]'
          label:    'Bounced Emails Queue'
          hint:     'Amount of bounced emails queued on the server'
          dependencies:
            'spam[detection_method_id]':    value: 1
            'spam[queue_type_ids]':         value: 3
        ,
          name:     'spam[sent_emails_count]'
          label:    'Sent Emails Count'
          hint:     'How many emails have already been sent?'
          dependencies:
            'spam[detection_method_id]':    value: 1
            'spam[queue_type_ids]':         value: 4
        ,
          name:     'spam[sent_emails_daterange]'
          label:    'Date Range'
          type:     'date_range_picker'
          hint:     'Select the period those emails were sent within'
          dateRangePickerOptions:
            ranges:
              'Yesterday':    [moment().subtract(1, 'days'),  moment().subtract(1, 'days')]
              'Last 7 Days':  [moment().subtract(6, 'days'),  moment()]
              'Last 30 Days': [moment().subtract(29, 'days'), moment()]
          dependencies:
            'spam[detection_method_id]':    value: 1
            'spam[queue_type_ids]':         value: 4
        ,
          name:     'spam[logs]'
          label:    'Log'
          tagName:  'textarea'
          dependencies:
            'spam[detection_method_id]':    value: 1
            'spam[queue_type_ids]':         value: 4
        ,
          name:     'spam[content_type_id]'
          label:    'Content Type'
          type:     'collection_radio_buttons'
          options:  @getSpamContentTypes()
          default:  1
          dependencies:
            'spam[detection_method_id]':  value: '1'
        ,
          name:     'spam[other_detection_method]'
          label:    'Other'
          tagName:  'textarea'
          hint:     'Please describe the incident in detail'
          dependencies:
            'spam[detection_method_id]':  value: '3'
        ,
          name:     'spam[header]'
          label:    'Header'
          tagName:  'textarea'
          dependencies:
            'spam[detection_method_id]':  value: 1
            'spam[queue_type_ids]':       value: [1, 2]
        ,
          name:     'spam[body]'
          label:    'Body'
          tagName:  'textarea'
          dependencies:
            'spam[detection_method_id]':  value: 1
            'spam[queue_type_ids]':       value: [1, 2]
        ,
          name:     'spam[bounce]'
          label:    'Bounce Example'
          tagName:  'textarea'
          dependencies:
            'spam[detection_method_id]':    value: 1
            'spam[queue_type_ids]':         value: 3
        ,
          name:     'spam[example_complaint]'
          label:    'Example / Link'
          tagName:  'textarea',
          hint:     'Feedback loop example or a link to one',
          dependencies:
            'spam[detection_method_id]':  value: '2'
        ,
          name:     'spam[reporting_party_ids]'
          label:    'Reporting Parties'
          type:     'collection_check_boxes'
          options:  @getSpamReportingParties()
          dependencies:
            'spam[detection_method_id]':  value: '2'
        ,
          name:     'spam[experts_enabled]'
          label:    'Spam Experts Enabled?'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          default:  true
          dependencies:
            service_id:                  value: ['1', '2']
            'spam[detection_method_id]': value: ['1', '2']
        ,
          name:     'spam[ip_is_blacklisted]'
          label:    'IPs are Blacklisted'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }, { name: "N/A", id: 'N/A' }]
          default:  false
          dependencies:
            'spam[detection_method_id]': value: ['1', '3']
        ,
          name:     'spam[blacklisted_ip]'
          label:    'Blacklisted IPs'
          tagName:  'textarea'
          hint:     'One IP address per line'
          dependencies: [
            'spam[detection_method_id]': value: ['1', '3']
            'spam[ip_is_blacklisted]':   value: 'true'
          ,
            'spam[detection_method_id]': value: ['1', '3']
            'service_id':                value: ['3', '4']
          ]
        ,
          name:     'spam[sent_by_cpanel]'
          label:    'Sent by'
          type:     'radio_buttons'
          options:  [{ name: "cPanel", id: true }, { name: "Mailbox(es)", id: false }]
          default:  true
          dependencies:
            'service_id':                value: [1, 2, 3, 4]
            'spam[detection_method_id]': value: 1
            'spam[queue_type_ids]':      value: 1
        ,
          name:     'spam[involved_mailboxes_count]'
          label:    'Involved Mailboxes Count'
          type:     'radio_buttons'
          options:  [{ name: '1', id: '1' }, { name: '2', id: '2' }, { name: '3', id: '3' }, { name: '4', id: '4' }, { name: 'more', id: 0 }]
          default:  1
          hint:     'How many abusive mailboxes are involved in the incident?'
          dependencies:
            'service_id':                value: [1, 2, 3, 4]
            'spam[detection_method_id]': value: 1
            'spam[queue_type_ids]':      value: 1
            'spam[sent_by_cpanel]':      value: 'false'
        ,
          name:     'spam[mailbox_password_reset]'
          label:    'Password Reset?'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          default:  true
          hint:     'Please reset password for all mailboxes reported'
          dependencies:
            'service_id':                     value: [1, 2, 3, 4]
            'spam[detection_method_id]':      value: 1
            'spam[involved_mailboxes_count]': value: [1, 2, 3, 4]
            'spam[queue_type_ids]':           value: 1
            'spam[sent_by_cpanel]':           value: 'false'
        ,
          name:     'spam[involved_mailboxes]'
          label:    'Mailbox(es) Involved'
          tagName:  'textarea'
          hint:     'Please provide all mailboxes reported'
          dependencies:
            'service_id':                     value: ['1', '2', '3', '4']
            'spam[detection_method_id]':      value: '1'
            'spam[involved_mailboxes_count]': value: ['1', '2', '3', '4']
            'spam[mailbox_password_reset]':   value: 'true'
            'spam[queue_type_ids]':           value: 1
            'spam[sent_by_cpanel]':           value: 'false'
        ,
          name:     'spam[mailbox_password_reset_reason]'
          label:    'Reason'
          tagName:  'textarea'
          dependencies:
            'service_id':                     value: ['1', '2', '3', '4']
            'spam[detection_method_id]':      value: '1'
            'spam[involved_mailboxes_count]': value: ['1', '2', '3', '4']
            'spam[mailbox_password_reset]':   value: 'false'
            'spam[queue_type_ids]':           value: 1
            'spam[sent_by_cpanel]':           value: 'false'
        ,
          name:     'spam[involved_mailboxes_count_other]'
          label:    'Exact / Approximate Amount'
          dependencies:
            'service_id':                     value: ['1', '2', '3', '4']
            'spam[detection_method_id]':      value: '1'
            'spam[involved_mailboxes_count]': value: '0'
            'spam[queue_type_ids]':           value: 1
            'spam[sent_by_cpanel]':           value: 'false'
        ,
          name:     'spam[reported_ip]'
          label:    'Reported IPs'
          tagName:  'textarea'
          hint:     'One IP address per line'
          dependencies:
            'spam[detection_method_id]': value: '2'
        ,
          name:     'spam[reported_ip_blacklisted]'
          label:    'IPs are Blacklisted'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          default:  true
          dependencies:
            'spam[detection_method_id]': value: '2'
        ]
      ,
        legend:     'Email Abuse / Spam'
        id:         'pe-spam'
        dependencies:
          type_id:    value: 1
          service_id: value: 5

        fields: [
          name:     'pe_spam[detection_method_id]'
          label:    'Detected by'
          type:     'collection_radio_buttons'
          options:  @getSpamDetectionMethods()
          default:  1
          hint:     'How was the issue detected?'
        ,
          name:     'pe_spam[pe_queue_type_ids]'
          label:    'Queue Type'
          type:     'collection_check_boxes'
          options:  @getSpamPeQueueTypes()
          default:  [1]
          dependencies:
            'pe_spam[detection_method_id]':  value: 1
        ,
          name:     'pe_spam[pe_content_type_id]'
          label:    'Content Type'
          type:     'collection_radio_buttons'
          options:  @getSpamPeContentTypes()
          default:  1
          dependencies:
            'pe_spam[detection_method_id]':  value: 1
        ,
          name:     'pe_spam[sent_emails_daterange]'
          label:    'Date Range'
          type:     'date_range_picker'
          hint:     'Select the period those emails were sent within'
          dateRangePickerOptions:
            ranges:
              'Yesterday':    [moment().subtract(1, 'days'),  moment().subtract(1, 'days')]
              'Last 7 Days':  [moment().subtract(6, 'days'),  moment()]
              'Last 30 Days': [moment().subtract(29, 'days'), moment()]
          dependencies:
            'pe_spam[detection_method_id]':    value: 1
            'pe_spam[pe_queue_type_ids]':      value: 1
        ,
          name:     'pe_spam[sent_emails_amount]'
          label:    'Sent Emails Amount'
          dependencies:
            'pe_spam[detection_method_id]':  value: 1
            'pe_spam[pe_queue_type_ids]':    value: 1
        ,
          name:     'pe_spam[recepients_per_email]'
          label:    'Recepients per Email'
          hint:     'Approximate amount of recepients per message if necessary'
          dependencies:
            'pe_spam[detection_method_id]':  value: 1
            'pe_spam[pe_queue_type_ids]':    value: 1
        ,
          name:     'pe_spam[example_complaint]'
          label:    'Example / Link'
          tagName:  'textarea',
          hint:     'Feedback loop example or a link to one',
          dependencies:
            'pe_spam[detection_method_id]':  value: '2'
        ,
          name:     'pe_spam[reporting_party_ids]'
          label:    'Reporting Parties'
          type:     'collection_check_boxes'
          options:  @getSpamReportingParties()
          dependencies:
            'pe_spam[detection_method_id]':  value: '2'
        ,
          name:     'pe_spam[reported_ip]'
          label:    'Reported IPs'
          tagName:  'textarea'
          hint:     'One IP address per line'
          dependencies:
            'pe_spam[detection_method_id]': value: '2'
        ,
          name:     'pe_spam[reported_ip_blacklisted]'
          label:    'IPs are Blacklisted'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          default:  true
          dependencies:
            'pe_spam[detection_method_id]': value: '2'
        ,
          name:     'pe_spam[other_detection_method]'
          label:    'Other'
          tagName:  'textarea'
          hint:     'Please describe the incident in detail'
          dependencies:
            'pe_spam[detection_method_id]':  value: '3'
        ,
          name:     'pe_spam[postfix_deferred_queue]'
          label:    'Postfix Deffered Queue'
          hint:     'Amount of emails queued on the server'
          dependencies:
            'pe_spam[detection_method_id]':  value: 1
            'pe_spam[pe_queue_type_ids]':    value: 2
        ,
          name:     'pe_spam[postfix_active_queue]'
          label:    'Postfix Active Queue'
          hint:     'Amount of emails queued on the server'
          dependencies:
            'pe_spam[detection_method_id]':  value: 1
            'pe_spam[pe_queue_type_ids]':    value: 3
        ,
          name:     'pe_spam[mailer_daemon_queue]'
          label:    'MAILER-DAEMON Queue'
          hint:     'Amount of emails queued on the server'
          dependencies:
            'pe_spam[detection_method_id]':  value: 1
            'pe_spam[pe_queue_type_ids]':    value: 4
        ,
          name:     'pe_spam[ip_is_blacklisted]'
          label:    'IPs are Blacklisted'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }, { name: "N/A", id: 'N/A' }]
          default:  false
          dependencies:
            'pe_spam[detection_method_id]': value: [1, 3]
        ,
          name:     'pe_spam[blacklisted_ip]'
          label:    'Blacklisted IPs'
          tagName:  'textarea'
          hint:     'One IP address per line'
          dependencies:
            'pe_spam[detection_method_id]': value: [1, 3]
            'pe_spam[ip_is_blacklisted]':   value: 'true'
        ,
          name:     'pe_spam[header]'
          label:    'Header'
          tagName:  'textarea'
          dependencies:
            'pe_spam[detection_method_id]': value: 1
            'pe_spam[pe_queue_type_ids]':   value: [1, 2, 3]
        ,
          name:     'pe_spam[body]'
          label:    'Body'
          tagName:  'textarea'
          dependencies:
            'pe_spam[detection_method_id]': value: 1
            'pe_spam[pe_queue_type_ids]':   value: [1, 2, 3]
        ,
          name:     'pe_spam[bounce]'
          label:    'Bounce'
          tagName:  'textarea'
          dependencies:
            'pe_spam[detection_method_id]': value: 1
            'pe_spam[pe_queue_type_ids]':   value: 4
        ,
          name:     'pe_spam[outbound_blocked]'
          label:    'Outbound Emails Blocked'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          default:  false
          dependencies:
            'pe_spam[detection_method_id]': value: 1
        ]
      ,
        legend:     'Resource Abuse'
        id:         'resource-abuse'
        dependencies:
            type_id:   value: '2'

        fields: [
          name:     'resource[type_id]'
          label:    'Resource Type'
          type:     'collection_radio_buttons'
          options:  @getResourceTypes()
          default:  1
          dependencies:
            service_id:               value: [1, 2, 3, 4]
        ,
          name:     'resource[details]'
          label:    'Details'
          tagName:  'textarea'
          hint:     'Most valuable folders (if a mailbox reserves more than 200, it should be provided separately)',
          dependencies: [
            service_id:               value: [1, 2, 3, 4]
            'resource[type_id]':      value: '1'
          ,
            service_id:               value: 5
          ]
        ,
          name:     'resource[abuse_type_ids]'
          label:    'Affected Resources'
          type:     'collection_check_boxes'
          hint:     'Please check all resources under impact'
          options:  @getResourceAbuseTypes()
          dependencies:
            service_id:               value: [1, 2, 3, 4]
            'resource[type_id]':      value: '2'
        ,
          name:     'resource[lve_report]'
          label:    'LVE Report'
          tagName:  'textarea'
          dependencies:
            service_id:                 value: [1, 2, 3, 4]
            'resource[type_id]':        value: '2'
            'resource[abuse_type_ids]': value: ['1', '2', '3', '4']
        ,
          name:     'resource[mysql_queries]'
          label:    'MySQL Queries'
          tagName:  'textarea'
          hint:     'Along with the command'
          dependencies:
            service_id:                 value: [1, 2, 3, 4]
            'resource[type_id]':        value: '2'
            'resource[abuse_type_ids]': value: '5'
        ,
          name:     'resource[db_governor_logs]'
          label:    'DB Governor Logs'
          tagName:  'textarea'
          hint:     'Without the command (since this is an internal tool)'
          dependencies:
            service_id:                 value: [1, 2, 3, 4]
            'resource[type_id]':        value: '2'
            'resource[abuse_type_ids]': value: '5'
        ,
          name:     'resource[process_logs]'
          label:    'Process Log'
          tagName:  'textarea'
          dependencies:
            service_id:               value: [1, 2, 3, 4]
            'resource[type_id]':       value: '2'
            'resource[abuse_type_ids]': value: '6'
        ,
          name:     'resource[upgrade_id]'
          label:    'Upgrade Suggestion'
          tagName:  'select'
          options:  @getResourceUpgrades()
          dependencies:
            service_id:               value: [1, 2, 3, 4]
            'resource[type_id]':       value: '2'
        ,
          name:     'resource[impact_id]'
          label:    'Severity of Impact'
          tagName:  'select'
          options:  @getResourceImpacts()
          hint:     'How much impact does it cause itself (i.e. is it able to overload the server on its own)?'
          dependencies:
            service_id:               value: [1, 2, 3, 4]
            'resource[type_id]':       value: '2'
        ,
          name:     'resource[activity_type_ids]'
          label:    'Activity Type'
          type:     'collection_check_boxes'
          default:  1
          options: @getResourceActivityTypes()
          dependencies:
            'resource[type_id]':      value: 3
        ,
          name:     'resource[measure_ids]'
          label:    'Measures taken'
          type:     'collection_check_boxes'
          options:  @getResourceMeasures()
          default:  1
          hint:     'What was done?'
          dependencies:
            'resource[type_id]':      value: 3
        ,
          name:     'resource[other_measure]'
          label:    'Other'
          dependencies:
            'resource[type_id]':      value: 3
            'resource[measure_ids]':   value: 3
        ]
      ,
        legend:     'DDoS'
        id:         'ddos'
        dependencies:
          type_id:   value: '3'

        fields: [
          name:     'ddos[domain_port]'
          label:    'Domain / Port'
        ,
          name:     'ddos[inbound]'
          label:    'Direction'
          type:     'radio_buttons'
          options:  [{ name: "Inbound", id: true }, { name: "Outbound", id: false }]
          default:  true
          dependencies:
            service_id:              value: [3, 4]
        ,
          name:     'ddos[block_type_id]'
          label:    'Block Type'
          type:     'collection_radio_buttons'
          options:  @getDdosBlockTypes()
          default:  1
          hint:     'Please mention the method of blocking'
          dependencies: [
            service_id:              value: [1, 2]
          ,
            service_id:              value: [3, 4]
            'ddos[inbound]':         value: true
          ]
        ,
          name:     'ddos[rule]'
          label:    'Rule / Command'
          hint:     'What rule was used for the block?'
          dependencies: [
            service_id:              value: [1, 2]
            'ddos[block_type_id]':   value: 3
          ,
            service_id:              value: [3, 4]
            'ddos[block_type_id]':   value: 3
            'ddos[inbound]':         value: true
          ]
        ,
          name:     'ddos[other_block_type]'
          label:    'Other'
          hint:     'Please specify as much as possible about the block'
          dependencies: [
            service_id:              value: [1, 2]
            'ddos[block_type_id]':    value: 4
          ,
            service_id:              value: [3, 4]
            'ddos[block_type_id]':    value: 4
            'ddos[inbound]':          value: true
          ]
        ,
          name:     'ddos[logs]'
          label:    'Log'
          tagName:  'textarea'
        ]
      ,
        legend:     'Other'
        id:         'other'
        hint:       'This option should only be selected if we have some activity that highly influences a shared server and it is
                     not possible to obtain standard evidences of Resource / Email Abuse.\nAccording to Namecheap internal policies,
                     generally, such activities *must not* be reported internally without an urgent reason. Legal & Abuse Shift Leader
                     might refuse taking actions if the reason/evidence provided is not enough for him/her to initiate a case.'
        dependencies:
          type_id:    value: 4

        fields: [
          name:     'other[abuse_type_ids]'
          label:    'Abuse Type'
          type:     'collection_check_boxes'
          options:  @getOtherAbuseTypes()
        ,
          name:     'other[domain_name]'
          label:    'Domain Name'
        ,
          name:     'other[url]'
          label:    'URL'
          hint:     'Exact URL to the infringing content'
        ,
          name:     'other[logs]'
          label:    'Log'
          tagName:  'textarea'
          hint:     "Either URL or Log must be provided, both fields can't be blank"
        ]
      ,
        legend:     'Conclusion'
        id:         'conclusion'
        dependencies:
          type_id:     value: [1, 2, 3, 4]

        fields: [
          name:     'suggestion_id'
          label:    'Suggested Action'
          tagName:  'select'
          options:  @getSuggestions()
          default:  3
          hint:     'Is it necessary to suspend the account or there is an amount of time to be provided?'
          callback: (fieldValues) ->
            if fieldValues.service_id?.toString() is '6'
              @trigger('enable:options', 6)
              @trigger('disable:options', [1, 2, 3, 4, 5])
            else
              @trigger('enable:options', [1, 2, 3, 4, 5])
              @trigger('disable:options', 6)

            if fieldValues.type_id?.toString() is '3' or (fieldValues.type_id?.toString() is '2' and fieldValues['resource[type_id]']?.toString() is '3')
              @trigger('enable:options', 8)
            else
              @trigger('disable:options', 8)
        ,
          name:     'suspension_reason'
          label:    'Reason'
          tagName:  'textarea'
          hint:     'Immediate suspension / time shortening reason'
          dependencies:
            suggestion_id:   value: ['1', '2', '4', '5']
        ,
          name:     'scan_report_path'
          label:    'Scan Report Path'
          hint:     'If account is suspended for queue (1000+) or Exim is stopped for managed server, please start CXS scan and save the report in homedir of the shared user/managed server'
          dependencies:
            suggestion_id:   value: 5
            type_id:         value: 1
            service_id:      value: [1, 2, 3, 4]
        ,
          name:     'tech_comments'
          label:    'Comments'
          tagName:  'textarea'
          hint:     'Anything you would like to add on this case. E.g. additional details, non-standard logs, notes, etc.'
        ,
          name:     'comment'
          label:    'Edit Reason'
          tagName:  'textarea'
          hint:     'Why is it necessary to edit the report?'
          dependencies:
            editCommentRequired: value: 'true'
        ]
      ]

    getOptions: (name) ->
      collection = App.request("legal:hosting:abuse:#{name}:entities")
      collection.map (item) ->
        item.attributes

    getServices:              -> @getOptions 'service'
    getAbuseTypes:            -> @getOptions 'type'
    getSharedPlans:           -> @getOptions 'shared:plan'
    getResellerPlans:         -> @getOptions 'reseller:plan'
    getVpsPlans:              -> @getOptions 'vps:plan'
    getManagementTypes:       -> @getOptions 'management:type'
    getSuggestions:           -> @getOptions 'suggestion'

    getDdosBlockTypes:        -> @getOptions 'ddos:block:type'

    getResourceAbuseTypes:    -> @getOptions 'resource:abuse:type'
    getResourceTypes:         -> @getOptions 'resource:type'
    getResourceUpgrades:      -> @getOptions 'resource:upgrade'
    getResourceImpacts:       -> @getOptions 'resource:impact'
    getResourceActivityTypes: -> @getOptions 'resource:activity:type'
    getResourceMeasures:      -> @getOptions 'resource:measure'

    getSpamReportingParties:  -> @getOptions 'spam:reporting:party'
    getSpamDetectionMethods:  -> @getOptions 'spam:detection:method'
    getSpamQueueTypes:        -> @getOptions 'spam:queue:type'
    getSpamPeQueueTypes:      -> @getOptions 'spam:pe:queue:type'
    getSpamContentTypes:      -> @getOptions 'spam:content:type'
    getSpamPeContentTypes:    -> @getOptions 'spam:pe:content:type'

    getOtherAbuseTypes:       -> @getOptions 'other:abuse:type'

    onShow: (view) ->
      _.defer ->
        view.$('#service_id').change()
        view.$("[id='pe_spam[pe_queue_type_ids]_1']").attr 'disabled', true
        _.each [1, 4, 7, 11], (num) -> view.$("[id='other[abuse_type_ids]_#{num}']").closest('.clearfix').css 'margin-bottom', '1rem'

    onServiceIdChange: (val, view) ->
      if s.isBlank(val) then view.$('#type_id').val('').change().attr('disabled', true) else view.$('#type_id').attr('disabled', false)

      view.$('#type_id').val('').change() if _.includes(@_prohibitedOptions[val], view.$('#type_id').val())

      view.$('#type_id option').attr('disabled', false)
      selector = @_prohibitedOptionsFor val
      view.$(selector).attr('disabled', true) unless s.isBlank(selector)

    _prohibitedOptions:
      '3': ['2']
      '4': ['2']
      '5': ['3', '4']
      '6': ['2', '3', '4']

    _prohibitedOptionsFor: (val) ->
      _.chain(@_prohibitedOptions[val]).map((option) -> "#type_id [value='#{option}']").join(', ').value()
