@Artoo.module 'DomainsCompensationStatsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Application

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
      schema = new Show.SearchSchema

      App.request 'form:fields:component',
        schema:  schema
        model:   stats

    getStatsView: (stats) ->
      new Show.StatsView
        model: stats

    getPanelView: ->
      new Show.Panel

    getLayoutView: ->
      new Show.Layout
