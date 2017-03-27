@Artoo.module 'LegalCfcRequestsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      requests = App.request 'cfc:requests:entities'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion requests
        @requestsRegion requests
        @paginationRegion requests

      @show @layout

    panelRegion: ->
      panelView = @getPanelView()

      @listenTo panelView, 'submit:request:clicked', ->
        App.vent.trigger 'submit:request:clicked'

      @show panelView, region: @layout.panelRegion

    searchRegion: (requests) ->
      searchView = @getSearchView()

      formView = App.request 'form:component', searchView,
        model: false

      @listenTo formView, 'form:submit', (data) ->
        requests.search data

      @show formView, region: @layout.searchRegion

    requestsRegion: (requests) ->
      requestsView = @getRequestsView requests

      @listenTo requestsView, 'childview:edit:cfc:request:clicked', (child, args) ->
        App.vent.trigger 'edit:cfc:request:clicked', args.model

      @listenTo requestsView, 'childview:verify:cfc:request:clicked', (child, args) ->
        App.vent.trigger 'verify:cfc:request:clicked', args.model

      @listenTo requestsView, 'childview:process:cfc:request:clicked', (child, args) ->
        App.vent.trigger 'process:cfc:request:clicked', args.model

      @show requestsView, region: @layout.requestsRegion

    paginationRegion: (requests) ->
      pagination = App.request 'pagination:component', requests

      App.execute 'when:synced', requests, =>
        @show pagination, region: @layout.paginationRegion if @layout.paginationRegion

    getRequestsView: (requests) ->
      new List.Requests
        collection: requests

    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false

    getPanelView: ->
      new List.Panel

    getLayoutView: ->
      new List.Layout
