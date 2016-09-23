@Artoo.module 'DomainsCompensationApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      console.log options
      compensation = App.request('new:compensation:entity')

      @layout = @getLayoutView()

      @listenTo @layout, 'show', ->
        @formRegion(compensation)

      @show @layout

    formRegion: (compensation) ->
      newView = @getNewView compensation

      form = App.request 'form:component', newView,
        model: compensation

      @show form, region: @layout.formRegion, loading: true

    getNewView: (compensation) ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  compensation

    getLayoutView: ->
      new New.Layout
