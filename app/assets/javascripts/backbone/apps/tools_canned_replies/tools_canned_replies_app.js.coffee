@Artoo.module 'ToolsCannedRepliesApp', (ToolsCannedRepliesApp, App, Backbone, Marionette, $, _) ->

  class ToolsCannedRepliesApp.Router extends App.Routers.Base

    appRoutes:
      'tools/canned_replies' : 'list'

  API =

    list: (region) ->
      return App.execute 'tools:list', 'Canned Replies', { action: 'list' } if not region
      new ToolsCannedRepliesApp.List.Controller
        region: region

  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Canned Replies'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/tools/canned_replies'
      API.list region

  ToolsCannedRepliesApp.on 'start', ->
    new ToolsCannedRepliesApp.Router
      controller: API


#
