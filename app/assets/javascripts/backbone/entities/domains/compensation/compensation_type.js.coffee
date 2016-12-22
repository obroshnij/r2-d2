@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation.CompensationType extends App.Entities.Model


  class Entities.Compensation.CompensationTypesCollection extends App.Entities.Collection
    model: Entities.Compensation.CompensationType


  API =

    newCompensationTypesCollection: (attrs = {}) ->
      new Entities.Compensation.CompensationTypesCollection attrs


  App.reqres.setHandler 'domains:compensation:type:entities', ->
    API.newCompensationTypesCollection App.entities.domains.compensation.compensation_type
