@Artoo.module 'ToolsCannedRepliesMacrosApp', (ToolsCannedRepliesMacrosApp, App, Backbone, Marionette, $, _) ->

  class ToolsCannedRepliesMacrosApp.Router extends App.Routers.Base

    appRoutes:
      'tools/canned_replies/macros' : 'list'

  API =
    list: (region) ->
      new ToolsCannedRepliesMacrosApp.List.Controller
        region: region

  App.vent.on 'tools:canned_replies:nav:selected', (nav, region) ->
    return if nav isnt 'Macro'

    API.list region
