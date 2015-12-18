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
    
    onHostingServiceChange: (val) ->
      console.log val