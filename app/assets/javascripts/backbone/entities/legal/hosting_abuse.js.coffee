@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse extends App.Entities.Model
    urlRoot: -> Routes.legal_hosting_abuse_index_path()
    
    defaults: ->
      'reported_by_id':                 App.request('get:current:user').get('id')
      'suggestion_id':                  3
      'spam[detection_method_id]':      1
      'spam[queue_type_id]':            1
      'spam[ip_is_blacklisted]':        false
      'spam[experts_enabled]':          true
      'spam[involved_mailboxes_count]': 1
      'spam[mailbox_password_reset]':   true
      'spam[reported_ip_blacklisted]':  true
      'spam[bounces_queue_present]':    false
      'ddos[block_type_id]':            1
      'resource[type_id]':              1
      'resource[activity_type_id]':     1
      'resource[measure_id]':           1
      
      
  class Entities.HostingAbuseCollection extends App.Entities.Collection
    model: Entities.HostingAbuse
    
    url: -> Routes.legal_hosting_abuse_index_path()
  
  
  class Entities.HostingAbuse.Ddos
  class Entities.HostingAbuse.Resource
  class Entities.HostingAbuse.Spam
  
  
  API =
  
    newReport: (attrs = {}) ->
      new Entities.HostingAbuse attrs
      
    getReportsCollection: ->
      reports = new Entities.HostingAbuseCollection
      reports.fetch
        reset: true
      reports
  
  
  App.reqres.setHandler 'new:hosting:abuse:entity', (attrs = {}) ->
    API.newReport attrs
    
  App.reqres.setHandler 'hosting:abuse:entities', ->
    API.getReportsCollection()