@Artoo.module 'HostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'hosting_abuse/new/layout'
    
    regions:
      formRegion: '#form-region'
  
  
  class New.Report extends App.Views.FormFields
    
    schema: ->
      [
        {
          legend: 'Client Details',
          id:     'client-details',
          fields: [
            {
              name:    'hosting_service',
              label:   'Service',
              tagName: 'select',
              options: @getServiceOptions(),
              hint:    'Abused service'
            }, {
              name:    'hosting_abuse_type',
              label:   'Abuse Type',
              tagName: 'select',
              options: @getAbuseTypeOptions(),
              hint:    'Type of the issue'
            }, {
              name:    'server_name',
              label:   'Server Name',
              hint:    'Ex: server78.web-hosting.com, host7.registrar-servers.com, etc.',
              dependencies: { 
                hosting_service: { value: ['shared', 'reseller', 'vps', 'dedicated'] }
              }
            }, {
              name:    'shared_package',
              label:   'Package',
              tagName: 'select',
              options: @getSharedPackages(),
              dependencies: {
                hosting_service: { value: 'shared' }
              }
            }, {
              name:    'reseller_package',
              label:   'Package',
              tagName: 'select',
              options: @getResellerPackages(),
              dependencies: {
                hosting_service: { value: 'reseller' }
              }
            }, {
              name:    'cpanel_username',
              label:   'cPanel Username',
              hint:    'Owner',
              dependencies: {
                hosting_service: { value: 'reseller' }
              }
            }, {
              name:    'username',
              label:   'Username',
              dependencies: {
                hosting_service: { value: ['shared', 'vps'] }
              }
            }, {
              name:    'resold_username',
              label:   'Resold Username',
              dependencies: {
                hosting_service: { value: 'reseller' }
              }
            }, {
              name:    'subscription_name',
              label:   'Subcription Name',
              dependencies: {
                hosting_service: { value: 'pe' }
              }
            }, {
              name:    'server_rack_label',
              label:   'Server Rack Label',
              hint:    'e.g. NC-PH-0731-26',
              dependencies: {
                hosting_service: { value: 'dedicated' }
              }
            }, {
              name:    'management_type',
              label:   'Type of Management',
              tagName: 'select',
              options: @getManagementTypes(),
              dependencies: {
                hosting_service: { value: ['dedicated', 'vps'] }
              }
            }
          ]
        }, {
          legend:  'Email Abuse / Spam',
          id:      'spam',
          dependencies: {
            hosting_abuse_type: { value: 'spam' }
          },
          fields: [
            {
              name:    'detection_methods',
              label:   'Detected by',
              type:    'collection_check_boxes',
              options: @getDetectionMethods(),
              hint:    'How the issue was detected?'
            }, {
              name:    'other_detection_method',
              label:   'Other'
              dependencies: {
                detection_methods: { value: 'other' }
              }
            }, {
              name:    'queue_amount'
              label:   'Queue Amount'
              dependencies: {
                detection_methods: { notExactValue: 'feedback_loop' }
              }
              hint:    'Amount of emails/bounces queued on the server, plus amount of recipients per message if necessary'
            }, {
              name:    'exim_stopped',
              label:   'Exim Stopped?',
              type:    'radio_buttons',
              options: [{ name: "Yes", value: true }, { name: "No", value: false }]
            }, {
              name:    'spam_experts_enabled'
              label:   'Spam Experts Enabled?'
              type:    'radio_buttons'
              options: [{ name: "Yes", value: true }, { name: "No", value: false }]
            }, {
              name:    'blacklisted_ip'
              label:   'Blacklisted IP'
              dependencies: {
                detection_methods: { value: 'blacklisted_ip' }
              }
            }, {
              name:    'header'
              label:   'Header'
              tagName: 'textarea'
              dependencies: {
                detection_methods: { value: ['queue_outbound', 'captcha', 'cms_notifications', 'forwarding_issue', 'mailbox_overflow'] }
              }
            }, {
              name:    'body'
              label:   'Body'
              tagName: 'textarea'
              dependencies: {
                detection_methods: { value: ['queue_outbound', 'captcha', 'cms_notifications', 'forwarding_issue', 'mailbox_overflow'] }
              }
            }, {
              name:    'bounce'
              label:   'Bounce'
              tagName: 'textarea'
              dependencies: {
                detection_methods: { value: 'queue_bounces' }
              }
            }, {
              name:    'example_complaint'
              label:   'Example / Link'
              tagName: 'textarea'
              dependencies: {
                detection_methods: { value: 'feedback_loop' }
              }
              hint:    'Feedback loop example or a link to one'
            }, {
              name:    'reporting_party'
              label:   'Reporting Party'
              tagName: 'select'
              options: @getReportingParties()
              dependencies: {
                detection_methods: { value: 'feedback_loop' }
              }
            }, {
              name:    'involved_mailboxes_count'
              label:   'Involved Mailboxes Count'
              type:    'radio_buttons'
              options: [{ name: '1', value: '1' }, { name: '2', value: '2' }, { name: '3', value: '3' }, { name: '4', value: '4' }, { name: 'more', value: 0 }]
              hint:    'If less than 5, please reset password for all of them'
            }, {
              name:    'mailbox_password_reset'
              label:   'Password Reset?'
              type:    'radio_buttons'
              options: [{ name: "Yes", value: true }, { name: "No", value: false }]
              dependencies: {
                involved_mailboxes_count: { value: ['1', '2', '3', '4'] }
              }
            }, {
              name:    'involved_mailboxes'
              label:   'Mailbox(es) Involved'
              tagName: 'textarea'
              dependencies: {
                involved_mailboxes_count: { value: ['1', '2', '3', '4'] }
                mailbox_password_reset:   { value: 'true' }
              }
            }, {
              name:    'mailbox_password_reset_reason'
              label:   'Reason'
              tagName: 'textarea'
              dependencies: {
                involved_mailboxes_count: { value: ['1', '2', '3', '4'] }
                mailbox_password_reset:   { value: 'false' }
              }
            }, {
              name:    'involved_mailboxes_count_other'
              label:   'Exact / Approximate Amount'
              type:    'number'
              dependencies: {
                involved_mailboxes_count: { value: '0' }
              }
            }
          ]
        }, {
          legend: 'Resource Abuse'
          id:     'resource-abuse'
          dependencies: {
            hosting_abuse_type: { value: 'resource' }
          }
          fields: [
            {
              name:    'resource_abuse_type'
              label:   'Resource Abuse Type'
              tagName: 'select'
              options: @getResourceAbuseTypes()
            }, {
              name:    'activity_type'
              label:   'Activity Type'
              tagName: 'select'
              options: @getActivityTypes()
              dependencies: {
                resource_abuse_type: { value: 'cron_job' }
              }
            }, {
              name:    'measure'
              label:   'Measures taken'
              type:    'collection_radio_buttons'
              options: @getMeasures()
              dependencies: {
                resource_abuse_type: { value: 'cron_job' }
              }
              hint:    'What was done?'
            }, {
              name:    'other_measure'
              label:   'Other'
              dependencies: {
                resource_abuse_type: { value: 'cron_job' }
                measure:             { value: 'other' }
              }
            }, {
              name:    'folders'
              label:   'Folders'
              tagName: 'textarea'
              hint:    'Most valuable folders (if a mailbox reserves more than 200, it should be provided separately)'
              dependencies: {
                resource_abuse_type: { value: 'disc_space' }
              }
            }, {
              name:    'resource_type'
              label:   'Resource Type'
              type:    'collection_check_boxes'
              hint:    'Please check all resources under impact'
              options: @getResourceTypes()
              dependencies: {
                resource_abuse_type: { value: 'lve_mysql' }
              }
            }, {
              name:    'lve_report'
              label:   'LVE Report'
              tagName: 'textarea'
              dependencies: {
                resource_abuse_type: { value: 'lve_mysql' }
                resource_type:       { value: ['cpu', 'memory', 'entry', 'io'] }
              }
            }, {
              name:    'mysql_queries'
              label:   'MySQL Queries'
              tagName: 'textarea'
              dependencies: {
                resource_abuse_type: { value: 'lve_mysql' }
                resource_type:       { value: 'mysql' }
              }
              hint:    'Along with the command'
            }, {
              name:    'process_logs'
              label:   'Process Logs'
              tagName: 'textarea'
              dependencies: {
                resource_abuse_type: { value: 'lve_mysql' }
                resource_type:       { value: 'processes' }
              }
            }, {
              name:    'upgrade_suggestion'
              label:   'Upgrade Suggestion'
              tagName: 'select'
              options: @getUpgradeSuggestions()
              dependencies: {
                resource_abuse_type: { value: 'lve_mysql' }
              }
            }, {
              name:    'impact'
              label:   'Severity of Impact'
              tagName: 'select'
              options: @getImpacts()
              dependencies: {
                resource_abuse_type: { value: 'lve_mysql' }
              }
              hint: 'How much impact it causes itself (i.e. is it able to overload the server itself)?'
            }
          ]
        }, {
          legend: 'DDoS'
          id:     'ddos'
          dependencies: {
            hosting_abuse_type: { value: 'ddos' }
          }
          fields: [
            {
              name:    'domain_port'
              label:   'Domain / Port'
            }, {
              name:    'block_type'
              label:   'Block Type'
              hint:    'Please mention the method of blocking'
            }, {
              name:    'ddos_logs'
              label:   'Logs'
              tagName: 'textarea'
            }
          ]
        }, {
          legend: 'Conclusion'
          id:     'conclusion'
          dependencies: {
            hosting_abuse_type: { value: ['spam', 'resource', 'ddos'] }
          }
          fields: [
            {
              name:     'suggestion'
              label:    'Suggestion'
              tagName:  'select'
              options:  @getSuggestions()
              blank_option: false
              hint:     'Is it necessary to suspend the account or there is an amount of time to be provided?'
            }, {
              name:     'suspension_reason'
              label:    'Reason'
              tagName:  'textarea'
              hint:     'Immediate suspension / time shortening reason'
              dependencies: {
                suggestion: { value: ['six', 'twelve', 'to_suspend'] }
              }
            }, {
              name:     'scan_report_path'
              label:    'Scan Report Path'
              dependencies: {
                suggestion: { value: 'suspended' }
              }
              hint: 'If account is suspended for queue (1000+) or Exim is stopped for managed server, please start CXS scan and save the report in homedir of the shared user/managed server'
            }, {
              name:     'comments'
              label:    'Additional Comments'
              tagName:  'textarea'
              hint:     'Anything you would like to add on this case (e.g. when a particular abuser is affecting the whole server)'
            }
          ]
        }
      ]
      
    getServiceOptions:     -> @getOptions App.request('hosting:abuse:service:entities')      
    getAbuseTypeOptions:   -> @getOptions App.request('hosting:abuse:type:entities')      
    getSharedPackages:     -> @getOptions App.request('hosting:abuse:shared:package:entities')      
    getResellerPackages:   -> @getOptions App.request('hosting:abuse:reseller:package:entities')      
    getManagementTypes:    -> @getOptions App.request('hosting:abuse:management:type:entities')      
    getDetectionMethods:   -> @getOptions App.request('hosting:abuse:spam:detection:method:entities')      
    getResourceAbuseTypes: -> @getOptions App.request('hosting:abuse:resource:abuse:type:entities')      
    getActivityTypes:      -> @getOptions App.request('hosting:abuse:resource:activity:type:entities')      
    getMeasures:           -> @getOptions App.request('hosting:abuse:resource:measure:entities')      
    getResourceTypes:      -> @getOptions App.request('hosting:abuse:resource:type:entities')      
    getUpgradeSuggestions: -> @getOptions App.request('hosting:abuse:resource:upgrade:suggestion:entities')      
    getImpacts:            -> @getOptions App.request('hosting:abuse:resource:impact:entities')      
    getSuggestions:        -> @getOptions App.request('hosting:abuse:suggestion:entities')      
    getReportingParties:   -> @getOptions App.request('hosting:abuse:spam:reporting:party:entities')
        
    onHostingServiceChange: (val) ->
      # @$("#hosting_abuse_type").val('').change()
      if s.isBlank(val) then @$("#hosting_abuse_type").attr('disabled', true) else @$("#hosting_abuse_type").attr('disabled', false)
      @$("#hosting_abuse_type option").attr('disabled', false)
      selector = @_prohibitedOptionsFor val
      @$(selector).attr('disabled', true) unless s.isBlank(selector)

    _prohibitedOptionsFor: (val) ->
      options =
        vps:       ['resource']
        dedicated: ['resource', 'ddos']
        pe:        ['resource', 'ddos']

      _.chain(options[val]).map((option) -> "#hosting_abuse_type [value='#{option}']").join(', ').value()