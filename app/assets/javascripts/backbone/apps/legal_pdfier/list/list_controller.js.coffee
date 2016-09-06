@Artoo.module 'LegalPdfierApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      reports = App.request 'pdf:report:entities'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @panelRegion reports
        @searchRegion reports
        @reportsRegion reports
        @paginationRegion reports

      @show @layout

    panelRegion: (reports) ->
      panelView = @getPanelView()

      @listenTo panelView, 'new:pdf:report:clicked', (args) ->
        App.vent.trigger 'new:pdf:report:clicked', reports

      @show panelView, region: @layout.panelRegion

    searchRegion: (reports) ->
      searchView = @getSearchView()

      formView = App.request 'form:component', searchView,
        model: false

      @listenTo formView, 'form:submit', (data) ->
        reports.search data

      @show formView, region: @layout.searchRegion

    reportsRegion: (reports) ->
      reportsView = @getReportsView reports

      @listenTo reportsView, 'childview:show:report:clicked', (args) ->
        App.vent.trigger 'show:report:clicked', args.model

      @show reportsView,
        loading: true
        region:  @layout.reportsRegion

    paginationRegion: (reports) ->
      pagination = App.request 'pagination:component', reports

      App.execute 'when:synced', reports, =>
        @show pagination, region: @layout.paginationRegion if @layout.paginationRegion

    getReportsView: (reports) ->
      new List.Reports
        collection: reports

    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false

    getPanelView: ->
      new List.Panel

    getLayoutView: ->
      new List.Layout
