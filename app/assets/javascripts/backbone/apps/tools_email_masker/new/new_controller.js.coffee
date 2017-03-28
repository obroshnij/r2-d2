@Artoo.module 'ToolsEmailMaskerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      masker = App.request 'email:masker:entity'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion masker

      @show @layout

    formRegion: (masker) ->
      newView = @getNewView()

      formView = App.request 'form:component', newView,
        model:          masker
        onBeforeSubmit: -> masker.unset('mask', silent: true)

      @listenTo formView, 'form:submit', (data) =>
        @resultRegion masker

      @show formView, region: @layout.formRegion

    resultRegion: (masker) ->
      resultView = @getResultView masker

      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'

      @show resultView,
        region:  @layout.resultRegion
        loading:
          loadingType: loadingType

    getResultView: (masker) ->
      new New.Result
        model: masker

    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false

    getLayoutView: ->
      new New.Layout
