@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation.AffectedProduct extends App.Entities.Model


  class Entities.Compensation.AffectedProductsCollection extends App.Entities.Collection
    model: Entities.Compensation.AffectedProduct


  API =

    newAffectedProductsCollection: (attrs = {}) ->
      new Entities.Compensation.AffectedProductsCollection attrs


  App.reqres.setHandler 'domains:compensation:affected:product:entities', ->
    API.newAffectedProductsCollection App.entities.domains.compensation.affected_product
