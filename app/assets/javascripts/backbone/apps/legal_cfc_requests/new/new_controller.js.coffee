@Artoo.module 'LegalCfcRequestsApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      request = if options.id then App.request('cfc:request:entity', options.id) else App.request('new:cfc:request:entity')

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion request

      @show @layout

    formRegion: (request) ->
      newView = @getNewView request

      form = App.request 'form:component', newView,
        model:     request
        onSuccess: -> App.vent.trigger 'cfc:request:created'
        onCancel:  -> App.vent.trigger 'new:cfc:request:cancelled'

      @show form, region: @layout.formRegion, loading: true

    getNewView: (request) ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema,
        model:  request

    getLayoutView: ->
      new New.Layout
