@Artoo.module 'DomainsCompensationApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @panelRegion()

      @show @layout

    panelRegion: ->
      panelView = @getPanelView()

      @listenTo panelView, 'new:compensation:clicked', (args) ->
        App.vent.trigger 'new:compensation:clicked'

      @show panelView, region: @layout.panelRegion

    getPanelView: ->
      new List.Panel

    getLayoutView: ->
      new List.Layout
