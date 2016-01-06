@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Spam.ReportingParty extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Spam.ReportingPartiesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Spam.ReportingParty
  
  
  API =
    
    newReportingPartiesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Spam.ReportingPartiesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:spam:reporting:party:entities', ->
    API.newReportingPartiesCollection App.entities.legal.hosting_abuse.spam.reporting_party