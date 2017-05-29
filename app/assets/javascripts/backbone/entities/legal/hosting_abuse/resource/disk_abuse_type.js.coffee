@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.HostingAbuse.Resource.DiskAbuseType extends App.Entities.Model


  class Entities.HostingAbuse.Resource.DiskAbuseTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.DiskAbuseType


  API =

    newDiskAbuseTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.DiskAbuseTypesCollection attrs


  App.reqres.setHandler 'legal:hosting:abuse:resource:disk:abuse:type:entities', ->
    API.newDiskAbuseTypesCollection App.entities.legal.hosting_abuse.resource.disk_abuse_type
