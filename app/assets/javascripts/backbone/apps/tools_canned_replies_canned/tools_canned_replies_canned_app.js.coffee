@Artoo.module 'ToolsCannedRepliesCannedApp', (ToolsCannedRepliesCannedApp, App, Backbone, Marionette, $, _) ->

  class ToolsCannedRepliesCannedApp.Router extends App.Routers.Base

    appRoutes:
      'tools/canned_replies/canned' : 'list'

  API =
    list: (region) ->
      new ToolsCannedRepliesCannedApp.List.Controller
        region: region

  App.vent.on 'tools:canned_replies:nav:selected', (nav, region) ->
    return if nav isnt 'Canned'

    API.list region
