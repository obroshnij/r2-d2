@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.HostingAbuse.Other.AbuseType extends App.Entities.Model
  
  
  class Entities.HostingAbuse.Other.AbuseTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Other.AbuseType
  
  
  API =
    
    newAbuseTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Other.AbuseTypesCollection attrs
  
  
  App.reqres.setHandler 'legal:hosting:abuse:other:abuse:type:entities', ->
    API.newAbuseTypesCollection App.entities.legal.hosting_abuse.other.abuse_type