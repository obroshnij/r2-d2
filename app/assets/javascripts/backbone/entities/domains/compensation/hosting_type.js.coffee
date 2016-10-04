@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation.HostingType extends App.Entities.Model


  class Entities.Compensation.HostingTypesCollection extends App.Entities.Collection
    model: Entities.Compensation.HostingType


  API =

    newHostingTypesCollection: (attrs = {}) ->
      new Entities.Compensation.HostingTypesCollection attrs


  App.reqres.setHandler 'domains:compensation:hosting:type:entities', ->
    API.newHostingTypesCollection App.entities.domains.compensation.hosting_type
