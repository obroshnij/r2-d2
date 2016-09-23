@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation extends App.Entities.Model
    urlRoot: ->

    resourceName: 'Domains::Compensation'


  class Entities.CompensationsCollection extends App.Entities.Collection
    model: Entities.Compensation


  API =

    getNewCompensation: ->
      new Entities.Compensation


  App.reqres.setHandler 'new:compensation:entity', ->
    API.getNewCompensation()
