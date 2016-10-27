@Artoo.module 'DomainsCompensationStatsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      stats = App.request 'domains:compensation:stats:entity'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', ->
        @panelRegion()
        @searchRegion stats
        @statsRegion stats

      @show @layout

    panelRegion: ->
      panelView = @getPanelView()

      @show panelView, region: @layout.panelRegion

    searchRegion: (stats) ->
      searchView = @getSearchView stats

      formView = App.request 'form:component', searchView,
        model:                stats
        deserialize:          true
        deserializeOnSuccess: true
        saveMethod:           'show'

      @show formView, region: @layout.searchRegion

    statsRegion: (stats) ->
      statsView = @getStatsView stats

      @show statsView,
        loading: true
        region:  @layout.statsRegion

    getSearchView: (stats) ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   stats

    getStatsView: (stats) ->
      new List.StatsView
        collection: stats

    getPanelView: ->
      new List.Panel

    getLayoutView: ->
      new List.Layout
