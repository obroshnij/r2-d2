@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse extends App.Entities.Model
    urlRoot: -> Routes.legal_hosting_abuse_index_path()
    
    resourceName: 'Legal::HostingAbuse'
    
    typeClassLookups: { 'Email Abuse / Spam': '', 'Resource Abuse': 'success', 'DDoS': 'secondary', 'Other': 'warning' }
    typeIconLookups:  { 'Email Abuse / Spam': 'fa fa-envelope-o', 'Resource Abuse': 'fa fa-sliders', 'DDoS': 'fa fa-bolt', 'Other': 'fa fa-fire' }
    
    statusColorLookups: { '_new': 'primary', '_processed': 'success', '_dismissed': 'alert', '_unprocessed': 'alert', '_edited': 'warning' }
    
    mutators:
      
      typeClass: ->
        @typeClassLookups[@get('type')] if @get('type')
        
      typeIcon: ->
        @typeIconLookups[@get('type')]  if @get('type')
        
      statusName: ->
        s(@get('status')).replaceAll('_', '').capitalize().value()
        
      statusColor: ->
        @statusColorLookups[@get('status')] if @get('status')
        
      doneBy: ->
        _.first(@get('logs')).done_by if @get('logs')
        
      doneAt: ->
        _.first(@get('logs')).created_at_formatted if @get('logs')
        
      editLog: ->
        return unless @get('logs')
        _.map @get('logs'), (log) ->
          line = s.capitalize(log.action) + ' by ' + log.done_by + ' at ' + log.created_at_formatted
          line = line + '\n' + 'Comment: ' + log.comment if log.comment and log.comment.length > 0
          line
        .join('\n\n')
        
      editCommentRequired: ->
        not @isNew()
        
      ticketCountBadgeClass: ->
        return 'secondary' if @get('ticket_reports_count') is 1
        return 'warning'   if @get('ticket_reports_count') > 1 and @get('ticket_reports_count') < 5
        'alert'
        
    markProcessed: (attributes = {}, options = {}) ->
      options.url = Routes.mark_processed_legal_hosting_abuse_path(@id)
      @save attributes, options
      
    markDismissed: (attributes = {}, options = {}) ->
      options.url = Routes.mark_dismissed_legal_hosting_abuse_path(@id)
      @save attributes, options
      
    markUnprocessed: (attributes = {}, options = {}) ->
      options.url = Routes.mark_unprocessed_legal_hosting_abuse_path(@id)
      @save attributes, options

      
  class Entities.HostingAbuseCollection extends App.Entities.Collection
    model: Entities.HostingAbuse
    
    url: -> Routes.legal_hosting_abuse_index_path()
  
  
  class Entities.HostingAbuse.Ddos
  class Entities.HostingAbuse.Resource
  class Entities.HostingAbuse.Spam
  class Entities.HostingAbuse.Other
  
  
  API =
  
    newReport: (attrs = {}) ->
      new Entities.HostingAbuse attrs
      
    getReportsCollection: ->
      reports = new Entities.HostingAbuseCollection
      reports.fetch()
      reports
      
    getReport: (id) ->
      report = new Entities.HostingAbuse id: id
      report.fetch()
      report
  
  
  App.reqres.setHandler 'new:hosting:abuse:entity', (attrs = {}) ->
    API.newReport attrs
    
  App.reqres.setHandler 'hosting:abuse:entities', ->
    API.getReportsCollection()
    
  App.reqres.setHandler 'hosting:abuse:entity', (id) ->
    API.getReport id