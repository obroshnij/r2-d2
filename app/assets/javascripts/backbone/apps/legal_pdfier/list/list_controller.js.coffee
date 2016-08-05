@Artoo.module 'LegalPdfierApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @panelRegion()

      @show @layout

    panelRegion: ->
      panelView = @getPanelView()

      @show panelView, region: @layout.panelRegion

    getPanelView: ->
      new List.Panel

    getLayoutView: ->
      new List.Layout
