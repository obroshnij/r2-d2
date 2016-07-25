@Artoo.module 'ToolsInternalDomainsApp', (ToolsInternalDomainsApp, App, Backbone, Marionette, $, _) ->

  class ToolsInternalDomainsApp.Router extends App.Routers.Base

    appRoutes:
      'tools/internal' : 'list'

  API =

    list: (region) ->
      return App.execute 'tools:list', 'Internal Domains', { action: 'list' } if not region

      new ToolsInternalDomainsApp.List.Controller
        region: region


  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Internal Domains'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/tools/internal'
      API.list region


  ToolsInternalDomainsApp.on 'start', ->
    new ToolsInternalDomainsApp.Router
      controller: API
