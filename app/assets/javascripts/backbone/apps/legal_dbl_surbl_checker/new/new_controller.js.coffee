@Artoo.module 'LegalDblSurblCheckerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      dbl_surbl = App.request 'new:dbl:surbl:ckecker:entity'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion dbl_surbl

      @show @layout

    formRegion: (dbl_surbl) ->
      newView = @getNewView()

      formView = App.request 'form:component', newView,
        model:          dbl_surbl
        onBeforeSubmit: -> dbl_surbl.records.reset(null, silent: true)

      @listenTo formView, 'form:submit', =>
        @resultRegion dbl_surbl

      @show formView, region: @layout.formRegion

    resultRegion: (dbl_surbl) ->
      resultView = @getResultView dbl_surbl.records

      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'

      @show resultView,
        loading:
          loadingType: loadingType
          entities:    dbl_surbl
        region:  @layout.resultRegion

    getResultView: (records) ->
      new New.Results
        collection: records

    getNewView: () ->
      schema = new New.Schema

      App.request 'form:fields:component',
        schema: schema
        model:  false

    getLayoutView: () ->
      new New.Layout
