@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.HostingAbuse.Resource.AbuseType extends App.Entities.Model


  class Entities.HostingAbuse.Resource.AbuseTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.AbuseType


  API =

    newAbuseTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.AbuseTypesCollection attrs


  App.reqres.setHandler 'legal:hosting:abuse:resource:abuse:type:entities', ->
    API.newAbuseTypesCollection App.entities.legal.hosting_abuse.resource.abuse_type
