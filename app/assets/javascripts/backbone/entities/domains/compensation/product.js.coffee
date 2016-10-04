@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation.Product extends App.Entities.Model


  class Entities.Compensation.ProductsCollection extends App.Entities.Collection
    model: Entities.Compensation.Product


  API =

    newProductsCollection: (attrs = {}) ->
      new Entities.Compensation.ProductsCollection attrs


  App.reqres.setHandler 'domains:compensation:product:entities', ->
    API.newProductsCollection App.entities.domains.compensation.product
