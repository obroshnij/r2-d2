@Artoo.module 'LegalCfcRequestsApp.Process', (Process, App, Backbone, Marionette, $, _) ->

  class Process.Controller extends App.Controllers.Application

    initialize: (options) ->
      request = App.request 'cfc:request:entity', options.id

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion request

      @show @layout

    formRegion: (request) ->
      processView = @getProcessView request

      form = App.request 'form:component', processView,
        model:      request
        saveMethod: 'process'
        onSuccess:  -> App.vent.trigger 'cfc:request:created'
        onCancel:   -> App.vent.trigger 'new:cfc:request:cancelled'
        onShow:     -> @$('.fieldset-hint > p').html("Required relations certainty is #{@model.get('certainty_threshold')}%")

      @show form, region: @layout.formRegion, loading: true

    getProcessView: (request) ->
      schema = new Process.FormSchema
      App.request 'form:fields:component',
        schema: schema,
        model:  request

    getLayoutView: ->
      new Process.Layout
