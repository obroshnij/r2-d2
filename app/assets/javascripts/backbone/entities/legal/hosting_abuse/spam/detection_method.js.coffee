@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Spam.DetectionMethod extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Spam.DetectionMethodsCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Spam.DetectionMethod
  
  
  API =
    
    newDetectionMethodsCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Spam.DetectionMethodsCollection attrs
  
  
  App.reqres.setHandler 'legal:hosting:abuse:spam:detection:method:entities', ->
    API.newDetectionMethodsCollection App.entities.legal.hosting_abuse.spam.detection_method