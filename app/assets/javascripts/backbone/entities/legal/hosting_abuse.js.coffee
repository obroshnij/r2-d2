@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse extends App.Entities.Model
    urlRoot: -> Routes.legal_hosting_abuse_index_path()
    
    defaults:
      'suggestion':                     '3'
      'spam[queue_type_id]':            '1'
      'spam[experts_enabled]':          'true'
      'spam[involved_mailboxes_count]': '1'
      'spam[mailbox_password_reset]':   'true'
      'ddos[block_type_id]':            '1'
      'resource[measure_id]':           '1'
  
  
  class Entities.HostingAbuse.Ddos
  class Entities.HostingAbuse.Resource
  class Entities.HostingAbuse.Spam
  
  
  API =
  
    newReport: (attrs = {}) ->
      new Entities.HostingAbuse attrs
  
  
  App.reqres.setHandler 'new:hosting:abuse:entity', (attrs = {}) ->
    API.newReport attrs