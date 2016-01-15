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
          hint:     'E.g.: server78.web-hosting.com, host7.registrar-servers.com, etc.'
          dependencies:
            service_id:      value: ['1', '2', '3', '4']
        ,
          name:     'shared_plan_id'
          label:    'Package'
          tagName:  'select'
          options:  @getSharedPlans()
          hint:     "Email Only (e.g. mailserver3.web-hosting.com) can only be abused by Email Abuse / Spam\nBusiness Expert can't abuse Disc-Space (150 GB allowed)"
          dependencies:
            service_id:      value: '1'
        ,
          name:     'reseller_plan_id'
          label:    'Package'
          tagName:  'select'
          options:  @getResellerPlans()
          dependencies:
            service_id:      value: '2'
        ,
          name:     'username'
          label:    'Username'
          dependencies:
            service_id:      value: ['1', '2']
        ,
          name:     'resold_username'
          label:    'Resold Username',
          dependencies:
            service_id:      value: '2'
        ,
          name:     'subscription_name'
          label:    'Subcription Name'
          dependencies:
            service_id:      value: '5'
        ,
          name:     'server_rack_label'
          label:    'Server Rack Label'
          hint:     'E.g. NC-PH-0731-26'
          dependencies:
            service_id:      value: '4'
        ,
          name:     'management_type_id'
          label:    'Type of Management'
          tagName:  'select'
          options:  @getManagementTypes()
          dependencies:
            service_id:      value: ['3', '4']
        ,
          name:     'vps_username'
          label:    'Username'
          dependencies:
            service_id:         value: ['3', '4']
            management_type_id: value: '3'
        ]
      ,
        legend:     'Email Abuse / Spam',
        id:         'spam',
        dependencies:
          type_id:     value: '1'
        
        fields: [
          name:     'spam[detection_method_id]'
          label:    'Detected by'
          type:     'collection_radio_buttons'
          options:  @getSpamDetectionMethods()
          hint:     'How was the issue detected?'
        ,
          name:     'spam[queue_type_id]'
          label:    'Queue Type'
          type:     'collection_radio_buttons'
          options:  @getSpamQueueTypes()
          dependencies:
            'spam[detection_method_id]':  value: '1'
        ,
          name:     'spam[bounces_queue_present]'
          label:    'Bounces Queue'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          hint:     'Are bounced emails being queued at the same time?'
          dependencies:
            'spam[detection_method_id]':  value: '1'
            'spam[queue_type_id]':        value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[other_detection_method]'
          label:    'Other'
          tagName:  'textarea'
          hint:     'Please describe the incident in detail'
          dependencies:
            'spam[detection_method_id]':  value: '3'
        ,
          name:     'spam[outgoing_emails_queue]'
          label:    'Outgoing Emails Queue'
          hint:     'Amount of emails queued on the server',
          dependencies:
            'spam[detection_method_id]':  value: '1'
            'spam[queue_type_id]':        value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[recepients_per_email]'
          label:    'Recepients per Email'
          hint:     'Amount of recipients per message if necessary',
          dependencies:
            'spam[detection_method_id]':  value: '1'
            'spam[queue_type_id]':        value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[bounced_emails_queue]'
          label:    'Bounced Emails Queue'
          hint:     'Amount of bounced emails queued on the server'
          dependencies: [
            'spam[detection_method_id]':    value: '1'
            'spam[queue_type_id]':          value: ['1', '2', '3', '4', '5']
            'spam[bounces_queue_present]':  value: 'true'
          ,
            'spam[detection_method_id]':  value: '1'
            'spam[queue_type_id]':        value: '6'
          ]
        ,
          name:     'spam[header]'
          label:    'Header'
          tagName:  'textarea'
          dependencies:
            'spam[detection_method_id]':  value: '1'
            'spam[queue_type_id]':        value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[body]'
          label:    'Body'
          tagName:  'textarea'
          dependencies:
            'spam[detection_method_id]':  value: '1'
            'spam[queue_type_id]':        value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[bounce]'
          label:    'Bounce Example'
          tagName:  'textarea'
          dependencies: [
            'spam[detection_method_id]':    value: '1'
            'spam[queue_type_id]':          value: ['1', '2', '3', '4', '5']
            'spam[bounces_queue_present]':  value: 'true'
          ,
            'spam[detection_method_id]':  value: '1'
            'spam[queue_type_id]':        value: '6'
          ]
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
          dependencies:
            service_id:                  value: ['1', '2']
            'spam[detection_method_id]': value: ['1', '2']
        ,
          name:     'spam[ip_is_blacklisted]'
          label:    'IP is Blacklisted'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }, { name: "N/A", id: '' }]
          dependencies:
            'spam[detection_method_id]': value: ['1', '3']
        ,
          name:     'spam[blacklisted_ip]'
          label:    'Blacklisted IP'
          dependencies:
            'spam[detection_method_id]': value: ['1', '3']
            'spam[ip_is_blacklisted]':   value: 'true'
        ,
          name:     'spam[involved_mailboxes_count]'
          label:    'Involved Mailboxes Count'
          type:     'radio_buttons'
          options:  [{ name: '1', id: '1' }, { name: '2', id: '2' }, { name: '3', id: '3' }, { name: '4', id: '4' }, { name: 'more', id: 0 }]
          hint:     'How many abusive mailboxes are involved in the incident?'
          dependencies:
            'service_id':                value: ['1', '2', '3', '4']
            'spam[detection_method_id]': value: '1'
            'spam[queue_type_id]':       value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[mailbox_password_reset]'
          label:    'Password Reset?'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          hint:     'Please reset password for all mailboxes reported'
          dependencies:
            'service_id':                     value: ['1', '2', '3', '4']
            'spam[detection_method_id]':      value: '1'
            'spam[involved_mailboxes_count]': value: ['1', '2', '3', '4']
            'spam[queue_type_id]':            value: ['1', '2', '3', '4', '5']
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
            'spam[queue_type_id]':            value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[mailbox_password_reset_reason]'
          label:    'Reason'
          tagName:  'textarea'
          dependencies:
            'service_id':                     value: ['1', '2', '3', '4']
            'spam[detection_method_id]':      value: '1'
            'spam[involved_mailboxes_count]': value: ['1', '2', '3', '4']
            'spam[mailbox_password_reset]':   value: 'false'
            'spam[queue_type_id]':            value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[involved_mailboxes_count_other]'
          label:    'Exact / Approximate Amount'
          dependencies:
            'service_id':                     value: ['1', '2', '3', '4']
            'spam[detection_method_id]':      value: '1'
            'spam[involved_mailboxes_count]': value: '0'
            'spam[queue_type_id]':            value: ['1', '2', '3', '4', '5']
        ,
          name:     'spam[reported_ip]'
          label:    'Reported IP'
          dependencies:
            'spam[detection_method_id]': value: '2'
        ,
          name:     'spam[reported_ip_blacklisted]'
          label:    'IP is Blacklisted'
          type:     'radio_buttons'
          options:  [{ name: "Yes", id: true }, { name: "No", id: false }]
          dependencies:
            'spam[detection_method_id]': value: '2'
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
        ,
          name:     'resource[activity_type_id]'
          label:    'Activity Type'
          type:     'radio_buttons'
          options: @getResourceActivityTypes()
          dependencies:
            'resource[type_id]':      value: '1'
        ,
          name:     'resource[measure_id]'
          label:    'Measures taken'
          type:     'collection_radio_buttons'
          options:  @getResourceMeasures()
          hint:     'What was done?'
          dependencies:
            'resource[type_id]':      value: '1'
        ,
          name:     'resource[other_measure]'
          label:    'Other'
          dependencies:
            'resource[type_id]':      value: '1'
            'resource[measure_id]':   value: '3'
        ,
          name:     'resource[folders]'
          label:    'Folders'
          tagName:  'textarea'
          hint:     'Most valuable folders (if a mailbox reserves more than 200, it should be provided separately)',
          dependencies:
            'resource[type_id]':      value: '2'
        ,
          name:     'resource[abuse_type_ids]'
          label:    'Resource Type'
          type:     'collection_check_boxes'
          hint:     'Please check all resources under impact'
          options:  @getResourceAbuseTypes()
          dependencies:
            'resource[type_id]':      value: '3'
        ,
          name:     'resource[lve_report]'
          label:    'LVE Report'
          tagName:  'textarea'
          dependencies:
            'resource[type_id]':        value: '3'
            'resource[abuse_type_ids]': value: ['1', '2', '3', '4']
        ,
          name:     'resource[mysql_queries]'
          label:    'MySQL Queries'
          tagName:  'textarea'
          hint:     'Along with the command'
          dependencies:
            'resource[type_id]':       value: '3'
            'resource[abuse_type_ids]': value: '5'
        ,
          name:     'resource[process_logs]'
          label:    'Process Logs'
          tagName:  'textarea'
          dependencies:
            'resource[type_id]':       value: '3'
            'resource[abuse_type_ids]': value: '6'
        ,
          name:     'resource[upgrade_id]'
          label:    'Upgrade Suggestion'
          tagName:  'select'
          options:  @getResourceUpgrades()
          dependencies:
            'resource[type_id]':       value: '3'
        ,
          name:     'resource[impact_id]'
          label:    'Severity of Impact'
          tagName:  'select'
          options:  @getResourceImpacts()
          hint:     'How much impact it causes itself (i.e. is it able to overload the server itself)?'
          dependencies:
            'resource[type_id]':       value: '3'
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
          name:     'ddos[block_type_id]'
          label:    'Block Type'
          type:     'collection_radio_buttons'
          options:  @getDdosBlockTypes()
          hint:     'Please mention the method of blocking'
        ,
          name:     'ddos[rule]'
          label:    'Rule'
          hint:     'What rule was used for the block?'
          dependencies:
            'ddos[block_type_id]':   value: '3'
        ,
          name:     'ddos[other_block_type]'
          label:    'Other'
          hint:     'Please specify as much as possible about the block'
          dependencies:
            'ddos[block_type_id]':    value: '4'
        ,
          name:     'ddos[logs]'
          label:    'Logs'
          tagName:  'textarea'
        ]
      ,
        legend:     'Conclusion'
        id:         'conclusion'
        dependencies:
          type_id:     value: ['1', '2', '3']
        
        fields: [
          name:     'suggestion_id'
          label:    'Suggestion'
          tagName:  'select'
          options:  @getSuggestions()
          hint:     'Is it necessary to suspend the account or there is an amount of time to be provided?'
        ,
          name:     'suspension_reason'
          label:    'Reason'
          tagName:  'textarea'
          hint:     'Immediate suspension / time shortening reason'
          dependencies:
            suggestion_id:   value: ['1', '2', '4']
        ,
          name:     'scan_report_path'
          label:    'Scan Report Path'
          hint:     'If account is suspended for queue (1000+) or Exim is stopped for managed server, please start CXS scan and save the report in homedir of the shared user/managed server'
          dependencies:
            suggestion_id:   value: '5'
        ,
          name:     'comments'
          label:    'Additional Comments'
          tagName:  'textarea'
          hint:     'Anything you would like to add on this case (e.g. when a particular abuser is affecting the whole server)'
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
    getManagementTypes:       -> @getOptions 'management:type'
    getSuggestions:           -> @getOptions 'suggestion'
    
    getDdosBlockTypes:        -> @getOptions 'ddos:block:type'
    
    getResourceAbuseTypes:    -> @getOptions 'resource:abuse:type'
    getResourceActivityTypes: -> @getOptions 'resource:activity:type'
    getResourceMeasures:      -> @getOptions 'resource:measure'
    getResourceTypes:         -> @getOptions 'resource:type'
    getResourceUpgrades:      -> @getOptions 'resource:upgrade'
    getResourceImpacts:       -> @getOptions 'resource:impact'
    
    getSpamReportingParties:  -> @getOptions 'spam:reporting:party'
    getSpamDetectionMethods:  -> @getOptions 'spam:detection:method'
    getSpamQueueTypes:        -> @getOptions 'spam:queue:type'
    
    onShow: (view) ->
      view.$('#service_id').change()

    onServiceIdChange: (val, view) ->
      if s.isBlank(val) then view.$('#type_id').val('').change().attr('disabled', true) else view.$('#type_id').attr('disabled', false)

      view.$('#type_id').val('').change() if _.includes(@_prohibitedOptions[val], view.$('#type_id').val())

      view.$('#type_id option').attr('disabled', false)
      selector = @_prohibitedOptionsFor val
      view.$(selector).attr('disabled', true) unless s.isBlank(selector)

    _prohibitedOptions:
      '3': ['2']
      '4': ['2', '3']
      '5': ['2', '3']

    _prohibitedOptionsFor: (val) ->
      _.chain(@_prohibitedOptions[val]).map((option) -> "#type_id [value='#{option}']").join(', ').value()