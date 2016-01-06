@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse extends App.Entities.Model
    
    defaults:
      exim_stopped:             'true'
      spam_experts_enabled:     'true'
      involved_mailboxes_count: '1'
      mailbox_password_reset:   'true'
      exact_amount:             'true'
      measure:                  'frequency_reduced'
      suggestion:               'twenty_four'
      ddos_block_type:          'haproxy'
      
      
  class Entities.HostingAbuse.Ddos
  class Entities.HostingAbuse.Resource
  class Entities.HostingAbuse.Spam
    
  
  API =
  
    newReport: (attrs = {}) ->
      new Entities.HostingAbuse attrs
  
  
  App.reqres.setHandler 'new:hosting:abuse:entity', (attrs = {}) ->
    API.newReport attrs