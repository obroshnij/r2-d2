@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.HostingAbuse.Resource.FileType extends App.Entities.Model


  class Entities.HostingAbuse.Resource.FileTypesCollection extends App.Entities.Collection
    model: Entities.HostingAbuse.Resource.FileType


  API =

    newFileTypesCollection: (attrs = {}) ->
      new Entities.HostingAbuse.Resource.FileTypesCollection attrs


  App.reqres.setHandler 'legal:hosting:abuse:resource:file:type:entities', ->
    API.newFileTypesCollection App.entities.legal.hosting_abuse.resource.file_type
