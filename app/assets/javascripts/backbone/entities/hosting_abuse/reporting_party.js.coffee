@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.ReportingParty extends App.Entities.Model
  
  
  class Entities.HostingAbuse.ReportingParties extends App.Entities.Collection
    model: Entities.HostingAbuse.ReportingParty
  
  
  API =
    
    newReportingParties: (params = {}) ->
      new Entities.HostingAbuse.ReportingParties params
  
  
  App.reqres.setHandler 'set:hosting:abuse:spam:reporting:party:entities', (params) ->
    App.entities.hostingAbuse.reportingParties = API.newReportingParties params
    
  App.reqres.setHandler 'hosting:abuse:spam:reporting:party:entities', ->
    App.entities.hostingAbuse.reportingParties