@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation.TierPricing extends App.Entities.Model


  class Entities.Compensation.TierPricingsCollection extends App.Entities.Collection
    model: Entities.Compensation.TierPricing


  API =

    newTierPricingsCollection: (attrs = {}) ->
      new Entities.Compensation.TierPricingsCollection attrs


  App.reqres.setHandler 'domains:compensation:tier:pricing:entities', ->
    API.newTierPricingsCollection App.entities.domains.compensation.tier_pricing
