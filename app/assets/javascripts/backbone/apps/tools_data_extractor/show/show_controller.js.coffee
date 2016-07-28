@Artoo.module 'ToolsDataExtractorApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Application

    initialize: (options) ->
      dataSearch = options.dataSearch

      detailsView = @getDetailsView dataSearch

      @show detailsView

    getDetailsView: (dataSearch) ->
      new Show.Details
        model: dataSearch
