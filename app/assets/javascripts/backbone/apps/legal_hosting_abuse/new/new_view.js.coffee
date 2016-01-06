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
          name:     'service'
          label:    'Service'
          tagName:  'select'
          options:  @getServices()
          hint:     'Abused service'
        ,
          name:     'abuse_type'
          label:    'Abuse Type'
          tagName:  'select'
          options:  @getAbuseTypes()
          hint:     'Type of the issue'
        ,
          name:     'server_name'
          label:    'Server Name'
          hint:     'Ex: server78.web-hosting.com, host7.registrar-servers.com, etc.'
          dependencies:
            service:      value: ['1', '2', '3', '4']
        ,
          name:     'shared_plan'
          label:    'Package'
          tagName:  'select'
          options:  @getSharedPlans()
          dependencies:
            service:      value: '1'
        ,
          name:     'reseller_plan'
          label:    'Package'
          tagName:  'select'
          options:  @getResellerPlans()
          dependencies:
            service:      value: '2'
        ,
          name:     'cpanel_username'
          label:    'cPanel Username'
          hint:     'Owner'
          dependencies:
            service:      value: '2'
        ,
          name:     'username'
          label:    'Username'
          dependencies:
            service:      value: ['1', '3']
        ,
          name:     'resold_username'
          label:    'Resold Username',
          dependencies:
            service:      value: '2'
        ,
          name:     'subscription_name'
          label:    'Subcription Name'
          dependencies:
            service:      value: '5'
        ,
          name:     'server_rack_label'
          label:    'Server Rack Label'
          hint:     'e.g. NC-PH-0731-26'
          dependencies:
            service:      value: '4'
        ,
          name:     'management_type'
          label:    'Type of Management'
          tagName:  'select'
          options:  @getManagementTypes()
          dependencies:
            service:      value: ['3', '4']
        ]
      ,
        legend:     'Email Abuse / Spam',
        id:         'spam',
        dependencies:
          abuse_type:     value: '1'
        
        fields: [
          name:     'spam_detection_methods'
          label:    'Detected by'
          type:     'collection_check_boxes'
          options:  @getSpamDetectionMethods()
          hint:     'How the issue was detected?'
        ,
          name:     'spam_queue_type'
          label:    'Queue Type'
          type:     'collection_radio_buttons'
          options:  @getSpamQueueTypes()
          dependencies:
            spam_detection_methods: value: '1'
        ,
          name:     'spam_other_detection_method'
          label:    'Other'
          dependencies:
            spam_detection_methods: value: '4'
        ,
          name:     'spam_header'
          label:    'Header'
          tagName:  'textarea'
          dependencies:
            spam_detection_methods: value: '1'
            spam_queue_type:        value: ['1', '3', '4', '5', '6']
        ,
          name:     'spam_body'
          label:    'Body'
          tagName:  'textarea'
          dependencies:
            spam_detection_methods: value: '1'
            spam_queue_type:        value: ['1', '3', '4', '5', '6']
        ,
          name:     'spam_bounce'
          label:    'Bounce'
          tagName:  'textarea'
          dependencies:
            spam_detection_methods: value: '1'
            spam_queue_type:        value: '2'
        ,
          name:     'spam_queue_amount'
          label:    'Queue Amount'
          hint:     'Amount of emails/bounces queued on the server, plus amount of recipients per message if necessary',
          dependencies:
            spam_detection_methods: otherThanExactly: '2'
        ,
          name:     'spam_blacklisted_ip'
          label:    'Blacklisted IP'
          dependencies:
            spam_detection_methods: value: '3'
        ,
          name:     'spam_example_complaint'
          label:    'Example / Link'
          tagName:  'textarea',
          hint:     'Feedback loop example or a link to one',
          dependencies:
            spam_detection_methods: value: '2'
        ,
          name:     'spam_reporting_party'
          label:    'Reporting Party'
          tagName:  'select'
          options:  @getSpamReportingParties()
          dependencies:
            spam_detection_methods: value: '2'
        ,
          name:     'spam_experts_enabled'
          label:    'Spam Experts Enabled?'
          type:     'radio_buttons'
          options:  [{ name: "Yes", value: true }, { name: "No", value: false }],
          dependencies:
            service:                value: ['1', '2']
        ,
          name:     'spam_involved_mailboxes_count'
          label:    'Involved Mailboxes Count'
          type:     'radio_buttons'
          options:  [{ name: '1', value: '1' }, { name: '2', value: '2' }, { name: '3', value: '3' }, { name: '4', value: '4' }, { name: 'more', value: 0 }]
          hint:     'If less than 5, please reset password for all of them'
        ,
          name:     'spam_mailbox_password_reset'
          label:    'Password Reset?'
          type:     'radio_buttons'
          options:  [{ name: "Yes", value: true }, { name: "No", value: false }]
          dependencies:
            spam_involved_mailboxes_count: value: ['1', '2', '3', '4']
        ,
          name:     'spam_involved_mailboxes'
          label:    'Mailbox(es) Involved'
          tagName:  'textarea'
          dependencies:
            spam_involved_mailboxes_count: value: ['1', '2', '3', '4']
            spam_mailbox_password_reset:   value: 'true'
        ,
          name:     'spam_mailbox_password_reset_reason'
          label:    'Reason'
          tagName:  'textarea'
          dependencies:
            spam_involved_mailboxes_count: value: ['1', '2', '3', '4']
            spam_mailbox_password_reset:   value: 'false'
        ,
          name:     'spam_involved_mailboxes_count_other'
          label:    'Exact / Approximate Amount'
          type:     'number'
          dependencies:
            spam_involved_mailboxes_count: value: '0'
        ]
      ,
        legend: 'Resource Abuse'
        id:     'resource-abuse'
        dependencies:
            abuse_type:   value: '2'

        fields: [
          name:     'resource_type'
          label:    'Resource Type'
          tagName:  'select'
          options:  @getResourceTypes()
        ,
          name:     'resource_activity_type'
          label:    'Activity Type'
          tagName:  'select'
          options: @getResourceActivityTypes()
          dependencies:
            resource_type:      value: '1'
        ,
          name:     'resource_measure'
          label:    'Measures taken'
          type:     'collection_radio_buttons'
          options:  @getResourceMeasures()
          hint:    'What was done?'
          dependencies:
            resource_type:      value: '1'
        ,
          name:     'other_measure'
          label:    'Other'
          dependencies:
            resource_type:      value: '1'
            resource_measure:   value: '3'
        ,
          name:     'resource_folders'
          label:    'Folders'
          tagName:  'textarea'
          hint:     'Most valuable folders (if a mailbox reserves more than 200, it should be provided separately)',
          dependencies:
            resource_type:      value: '2'
        ,
          name:     'resource_abuse_type'
          label:    'Resource Type'
          type:     'collection_check_boxes'
          hint:     'Please check all resources under impact'
          options:  @getResourceAbuseTypes()
          dependencies:
            resource_type:      value: '3'
        ,
          name:     'resource_lve_report'
          label:    'LVE Report'
          tagName:  'textarea'
          dependencies:
            resource_type:       value: '3'
            resource_abuse_type: value: ['1', '2', '3', '4']
        ,
          name:     'resource_mysql_queries'
          label:    'MySQL Queries'
          tagName:  'textarea'
          hint:     'Along with the command'
          dependencies:
            resource_type:       value: '3'
            resource_abuse_type: value: '5'
        ,
          name:     'resource_process_logs'
          label:    'Process Logs'
          tagName:  'textarea'
          dependencies:
            resource_type:       value: '3'
            resource_abuse_type: value: '6'
        ,
          name:     'resource_upgrade'
          label:    'Upgrade Suggestion'
          tagName:  'select'
          options:  @getResourceUpgrades()
          dependencies:
            resource_type:       value: '3'
        ,
          name:     'resource_impact'
          label:    'Severity of Impact'
          tagName:  'select'
          options:  @getResourceImpacts()
          hint:     'How much impact it causes itself (i.e. is it able to overload the server itself)?'
          dependencies:
            resource_type:       value: '3'
        ]
      ,
        legend:     'DDoS'
        id:         'ddos'
        dependencies:
          abuse_type:   value: '3'
        
        fields: [
          name:     'ddos_domain_port'
          label:    'Domain / Port'
        ,
          name:     'ddos_block_type'
          label:    'Block Type'
          type:     'collection_radio_buttons'
          options:  @getDdosBlockTypes()
          hint:     'Please mention the method of blocking'
        ,
          name:     'other_ddos_block_type'
          label:    'Other'
          dependencies:
            ddos_block_type:    value: '5'
        ,
          name:     'ddos_logs'
          label:    'Logs'
          tagName:  'textarea'
        ]
      ,
        legend:     'Conclusion'
        id:         'conclusion'
        dependencies:
          abuse_type:     value: ['1', '2', '3']
        
        fields: [
          name:     'suggestion'
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
            suggestion:   value: ['1', '2', '4']
        ,
          name:     'scan_report_path'
          label:    'Scan Report Path'
          hint:     'If account is suspended for queue (1000+) or Exim is stopped for managed server, please start CXS scan and save the report in homedir of the shared user/managed server'
          dependencies:
            suggestion:   value: '5'
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
    
    # onServiceChange: (val) ->
    #   @$("#hosting_abuse_type").val('').change()
    #   if s.isBlank(val) then @$("#hosting_abuse_type").attr('disabled', true) else @$("#hosting_abuse_type").attr('disabled', false)
    #   @$("#hosting_abuse_type option").attr('disabled', false)
    #   selector = @_prohibitedOptionsFor val
    #   @$(selector).attr('disabled', true) unless s.isBlank(selector)
    #
    # _prohibitedOptionsFor: (val) ->
    #   options =
    #     vps:       ['resource']
    #     dedicated: ['resource', 'ddos']
    #     pe:        ['resource', 'ddos']
    #
    #   _.chain(options[val]).map((option) -> "#hosting_abuse_type [value='#{option}']").join(', ').value()