@Artoo.module 'ToolsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      toolsNavs = App.request 'tools:nav:entities'
      return App.vent.trigger 'access:denied' if toolsNavs.length is 0

      @listenTo toolsNavs, 'select:one', (model, collection, options) ->
        App.vent.trigger 'tools:nav:selected', model.get('name'), @options.options, @layout.articleRegion

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @titleRegion()
        @breadcrumbsRegion toolsNavs
        @navsRegion toolsNavs, options.nav

      @show @layout

      delete @options.options # action is only needed once, when the app is initiated

    titleRegion: ->
      titleView = @getTitleView()
      @show titleView, region: @layout.titleRegion

    breadcrumbsRegion: (toolsNavs) ->
      breadcrumbsView = @getBreadcrumbs toolsNavs
      @show breadcrumbsView, region: @layout.breadcrumbsRegion

    navsRegion: (toolsNavs, nav) ->
      toolsNavs.selectByName nav
      toolsNavsView = @getToolsNavsView toolsNavs
      @show toolsNavsView, region: @layout.toolsNavsRegion

    getTitleView: ->
      new List.Title

    getBreadcrumbs: (toolsNavs) ->
      new List.Breadcrumbs
        collection: toolsNavs

    getToolsNavsView: (toolsNavs) ->
      new List.Navs
        collection: toolsNavs

    getLayoutView: ->
      new List.Layout
