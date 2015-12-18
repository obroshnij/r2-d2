@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Report extends App.Entities.Model
  
      
  API =
    
    newReport: (params = {}) ->
      new Entities.HostingAbuse.Report params
  
    
  App.reqres.setHandler 'new:hosting:abuse:report:entity', ->
    API.newReport()