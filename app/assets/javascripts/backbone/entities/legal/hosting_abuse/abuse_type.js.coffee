@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.AbuseType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.AbuseTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.AbuseType
  
   
  API =
    
    newAbuseAbuseTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.AbuseTypesCollection attrs
  
    
  App.reqres.setHandler 'legal:hosting:abuse:type:entities', ->
    API.newAbuseAbuseTypesCollection App.entities.legal.hosting_abuse.type