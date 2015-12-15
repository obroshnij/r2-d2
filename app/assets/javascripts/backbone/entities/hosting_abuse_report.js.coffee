@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuseReport extends App.Entities.Model
  
  class Entities.HostingAbuseReports extends App.Entities.Collection
    model: Entities.HostingAbuseReport
    
  API =
    
    newHostingAbuseReport: ->
      new Entities.HostingAbuseReport
    
  App.reqres.setHandler 'new:hosting:abuse:report:entity', ->
    API.newHostingAbuseReport()