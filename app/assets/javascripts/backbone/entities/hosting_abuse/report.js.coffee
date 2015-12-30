@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Report extends App.Entities.Model
    
    defaults:
      exim_stopped:             'true'
      spam_experts_enabled:     'true'
      involved_mailboxes_count: '1'
      mailbox_password_reset:   'true'
      exact_amount:             'true'
      measure:                  'frequency_reduced'
      suggestion:               'twenty_four'
  
        
  API =
    
    newReport: (params = {}) ->
      new Entities.HostingAbuse.Report params
  
    
  App.reqres.setHandler 'new:hosting:abuse:report:entity', ->
    API.newReport()