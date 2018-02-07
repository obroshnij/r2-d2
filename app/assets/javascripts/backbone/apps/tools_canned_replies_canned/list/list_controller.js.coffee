@Artoo.module 'ToolsCannedRepliesCannedApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      @layout = @getLayoutView()
      @data = @getTreeData();

      @listenTo @layout, 'show', ->
        @showTree @data

      @show @layout

    showTree: (data) ->
      view = @getRootsTreeView(data)

      @listenTo view, 'childview:expand:clicked', (child, args) ->
        child.expand()

      @show view, region: @layout.contentRegion

    renderChildContent: (view, model) ->
      childTree = @getTreeView(model.get('nodes'))

      @show childTree, region: view.childrenRegion

    getTreeData: ->
      return App.request 'tools:canned_replies:canned:entities'

    getTreeView: (treeData)->
      new List.Tree
        collection: treeData

    getRootsTreeView: (treeData) ->
      new List.TreeRoots
        collection: treeData

    getLayoutView: ->
      new List.Layout


        # App.vent.trigger 'tools:canned_replies:expand:category', child, args.model
