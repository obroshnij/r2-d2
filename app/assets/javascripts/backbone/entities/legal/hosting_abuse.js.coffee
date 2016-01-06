@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse extends App.Entities.Model
    
    defaults:
      suggestion:                    '3'
      ddos_block_type:               '1'
      resource_measure:              '1'
      spam_queue_type:               '1'
      spam_experts_enabled:          'true'
      spam_involved_mailboxes_count: '1'
      spam_mailbox_password_reset:   'true'
      
      
  class Entities.HostingAbuse.Ddos
  class Entities.HostingAbuse.Resource
  class Entities.HostingAbuse.Spam
    
  
  API =
  
    newReport: (attrs = {}) ->
      new Entities.HostingAbuse attrs
  
  
  App.reqres.setHandler 'new:hosting:abuse:entity', (attrs = {}) ->
    API.newReport attrs