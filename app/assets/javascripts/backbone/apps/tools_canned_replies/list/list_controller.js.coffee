@Artoo.module 'ToolsCannedRepliesApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      navs = App.request 'tools:canned_replies:nav:entities'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @navRegion navs

      @listenTo navs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'tools:canned_replies:nav:selected', model.get('name'), @layout.contentRegion

      @show @layout

      _.defer => navs.first().select()

    navRegion: (navs) ->
      view = @getNavView navs
      @show view, region: @layout.navRegion

    getNavView: (navs) ->
      new List.Navigation
        collection: navs

    getLayoutView: ->
      new List.Layout
