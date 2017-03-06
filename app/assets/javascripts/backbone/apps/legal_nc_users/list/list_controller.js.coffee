@Artoo.module 'LegalNcUsersApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      ncUsers   = App.request 'list:nc:users:entities'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @panelRegion()
        @searchRegion ncUsers
        @ncUsersRegion ncUsers
        @paginationRegion ncUsers

      @show @layout

    panelRegion: ->
      panelView = @getPanelView()

      @listenTo panelView, 'new:legal:nc:user:clicked', ->
        App.vent.trigger 'new:legal:nc:user:clicked'

      @show panelView, region: @layout.panelRegion

    searchRegion: (reports) ->
      searchView = @getSearchView()

      formView = App.request 'form:component', searchView,
        model: false

      @listenTo formView, 'form:submit', (data) ->
        reports.search data

      @show formView, region: @layout.searchRegion

    ncUsersRegion: (ncUsers) ->
      ncUsersView = @getNcUsersView ncUsers

      @listenTo ncUsersView, 'childview:show:clicked', (child, args) ->
        App.vent.trigger 'show:nc:users:clicked', args.model

      @show ncUsersView, region: @layout.ncUsersRegion, loading: true

    getNcUsersView: (ncUsers) ->
      new List.NcUsersView
        collection: ncUsers

    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false

    paginationRegion: (ncUsers) ->
      pagination = App.request 'pagination:component', ncUsers

      App.execute 'when:synced', ncUsers, =>
        @show pagination, region: @layout.paginationRegion if @layout.paginationRegion

    getPanelView: ->
      new List.Panel

    getLayoutView: ->
      new List.Layout
