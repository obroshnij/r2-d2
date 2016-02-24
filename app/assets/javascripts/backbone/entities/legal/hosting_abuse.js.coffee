@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse extends App.Entities.Model
    urlRoot: -> Routes.legal_hosting_abuse_index_path()
    
    typeClassLookups: { 'Email Abuse / Spam': '', 'Resource Abuse': 'success', 'DDoS': 'secondary', 'Other': 'warning' }
    
    typeIconLookups:  { 'Email Abuse / Spam': 'fa fa-envelope-o', 'Resource Abuse': 'fa fa-sliders', 'DDoS': 'fa fa-bolt', 'Other': 'fa fa-fire' }
    
    mutators:
            
      typeClass: ->
        @typeClassLookups[@get('type')] if @get('type')
        
      typeIcon: ->
        @typeIconLookups[@get('type')]  if @get('type')
      
      
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