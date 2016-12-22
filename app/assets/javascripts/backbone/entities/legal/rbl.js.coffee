@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Rbl extends App.Entities.Model
    urlRoot: -> Routes.legal_rbls_path()

    resourceName: 'Legal::Rbl'

    statusColorLookups: { 'Unimportant': 'primary', 'Urgent': 'alert', 'Important': 'warning' }

    mutators:

      statusColor: ->
        @statusColorLookups[@get('status_name')] if @get('status_name')


  class Entities.RblsCollection extends App.Entities.Collection
    model: Entities.Rbl

    url: -> Routes.legal_rbls_path()


  API =

    getRblsCollection: ->
      rbls = new Entities.RblsCollection
      rbls.fetch()
      rbls

    getNewRbl: ->
      new Entities.Rbl


  App.reqres.setHandler 'legal:rbl:entities', ->
    API.getRblsCollection()

  App.reqres.setHandler 'new:legal:rbl:entity', ->
    API.getNewRbl()
