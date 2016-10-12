@Artoo.module 'DomainsCompensationApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      compensations = App.request 'compensation:entities'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion compensations
        @compensationsRegion compensations
        @paginationRegion compensations

      @show @layout

    panelRegion: ->
      panelView = @getPanelView()

      @listenTo panelView, 'new:compensation:clicked', (args) ->
        App.vent.trigger 'new:compensation:clicked'

      @show panelView, region: @layout.panelRegion

    searchRegion: (compensations) ->
      searchView = @getSearchView()

      formView = App.request 'form:component', searchView,
        model: false

      @listenTo formView, 'form:submit', (data) ->
        compensations.search data

      @show formView, region: @layout.searchRegion

    compensationsRegion: (compensations) ->
      compensationsView = @getCompensationsView compensations

      @listenTo compensationsView, 'childview:edit:compensation:clicked', (child, args) ->
        App.vent.trigger 'edit:compensation:clicked', args.model

      @show compensationsView,
        loading: true,
        region:  @layout.compensationsRegion

    paginationRegion: (compenstions) ->
      pagination = App.request 'pagination:component', compenstions

      App.execute 'when:synced', compenstions, =>
        @show pagination, region: @layout.paginationRegion if @layout.paginationRegion

    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false

    getCompensationsView: (compensations) ->
      new List.Compensations
        collection: compensations

    getPanelView: ->
      new List.Panel

    getLayoutView: ->
      new List.Layout
