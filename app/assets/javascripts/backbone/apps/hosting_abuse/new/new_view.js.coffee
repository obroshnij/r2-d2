@Artoo.module 'HostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'hosting_abuse/new/layout'
    
    regions:
      formRegion: '#form-region'
  
  
  class New.FormFields extends App.Views.FormFields
    
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
          legend:  'Spam',
          id:      'spam',
          dependencies: {
            hosting_abuse_type: { value: 'spam' }
          },
          fields: [
            {
              name:  'blacklisted_ip',
              label: 'Blacklisted IP'
            }
          ]
        }, {
          legend: 'IP Feedback',
          id:     'ip-feedback',
          dependencies: {
            hosting_abuse_type: { value: 'ip_feedback' }
          },
          fields: [
            {
              name:  'reporting_party',
              label: 'Reporting Party',
              hint:  'MS, Symantec, etc.'
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
    
    
    onHostingServiceChange: (val) ->
      @$("#hosting_abuse_type").val('').change()
      if s.isBlank(val) then @$("#hosting_abuse_type").attr('disabled', true) else @$("#hosting_abuse_type").attr('disabled', false)
      @$("#hosting_abuse_type option").attr('disabled', false)
      selector = @_prohibitedOptionsFor val
      @$(selector).attr('disabled', true) unless s.isBlank(selector)
      
    _prohibitedOptionsFor: (val) ->
      options = 
        vps:       ['lve_mysql', 'disc_space', 'cron_job']
        dedicated: ['lve_mysql', 'disc_space', 'cron_job', 'ddos']
        pe:        ['lve_mysql', 'disc_space', 'cron_job', 'ddos', 'ip_feedback']
      
      _.chain(options[val]).map((option) -> "#hosting_abuse_type [value='#{option}']").join(', ').value()