@Artoo.module 'ToolsCannedRepliesMacrosApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      @layout = @getLayoutView()
      @data = @getTreeData();

      @listenTo @layout, 'show', ->
        @showSearch @data
        @showTree @data

      @show @layout

    showTree: (data) ->
      view = @getRootsTreeView(data)

      @listenTo view, 'childview:expand:clicked', (child, args) ->
        child.expand()

      @show view, region: @layout.contentRegion

    showSearch: (treeData) ->
      searchView = @getSearchView()

      formView = App.request 'form:component', searchView,
        model: false

      @listenTo formView, 'form:submit', (data) ->
        treeData.search data

      @show formView, region: @layout.searchRegion

    getSearchView: ->
      schema = new List.SearchSchema

      App.request 'form:fields:component',
        schema:  schema
        model:   false

    renderChildContent: (view, model) ->
      childTree = @getTreeView(model.get('nodes'))

      @show childTree, region: view.childrenRegion

    getTreeData: ->
      return App.request 'tools:canned_replies:macros:entities'

    getTreeView: (treeData)->
      new List.Tree
        collection: treeData

    getRootsTreeView: (treeData) ->
      new List.TreeRoots
        collection: treeData

    getLayoutView: ->
      new List.Layout
