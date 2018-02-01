@Artoo.module 'ToolsCannedRepliesApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @fileInput()
        @repliesList()

      @show @layout

    fileInput: () ->
      view = @getFileInputView()

      @listenTo view, 'import:tools:canned_replies:clicked', (args) ->
        App.vent.trigger 'import:tools:canned_replies:clicked'

      @show view, region: @layout.fileInput

    repliesList: () ->
      view = @getRepliesListView()

      @show view, region: @layout.repliesList

    getFileInputView: ->
      new List.FileInput

    getRepliesListView: ->
      new List.RepliesList

    getLayoutView: ->
      new List.Layout
