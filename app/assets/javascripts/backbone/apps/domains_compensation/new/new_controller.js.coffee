@Artoo.module 'DomainsCompensationApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      compensation = if options.id then App.request('compensation:entity', options.id) else App.request('new:compensation:entity')

      @layout = @getLayoutView()

      @listenTo @layout, 'show', ->
        @formRegion compensation

      @show @layout

    formRegion: (compensation) ->
      newView = @getNewView compensation

      form = App.request 'form:component', newView,
        model:     compensation
        onSuccess: -> App.vent.trigger 'domains:compensation:created', compensation
        onCancel:  -> App.vent.trigger 'new:domains:compensation:cancelled'

      @show form, region: @layout.formRegion, loading: true

    getNewView: (compensation) ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  compensation

    getLayoutView: ->
      new New.Layout
