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
              label:   'Feedback Loop Example'
              tagName: 'textarea'
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
        }
      ]
      
    getServiceOptions: ->
      @getOptions App.request('hosting:abuse:service:entities')
      
    getAbuseTypeOptions: ->
      @getOptions App.request('hosting:abuse:type:entities')
      
    getSharedPackages: ->
      @getOptions App.request('hosting:abuse:shared:package:entities')
      
    getResellerPackages: ->
      @getOptions App.request('hosting:abuse:reseller:package:entities')
      
    getManagementTypes: ->
      @getOptions App.request('hosting:abuse:management:type:entities')
      
    getDetectionMethods: ->
      @getOptions App.request('hosting:abuse:spam:detection:method:entities')
      

    # onHostingServiceChange: (val) ->
    #   @$("#hosting_abuse_type").val('').change()
    #   if s.isBlank(val) then @$("#hosting_abuse_type").attr('disabled', true) else @$("#hosting_abuse_type").attr('disabled', false)
    #   @$("#hosting_abuse_type option").attr('disabled', false)
    #   selector = @_prohibitedOptionsFor val
    #   @$(selector).attr('disabled', true) unless s.isBlank(selector)
    #
    # _prohibitedOptionsFor: (val) ->
    #   options =
    #     vps:       ['lve_mysql', 'disc_space', 'cron_job']
    #     dedicated: ['lve_mysql', 'disc_space', 'cron_job', 'ddos']
    #     pe:        ['lve_mysql', 'disc_space', 'cron_job', 'ddos', 'ip_feedback']
    #
    #   _.chain(options[val]).map((option) -> "#hosting_abuse_type [value='#{option}']").join(', ').value()