@Artoo.module 'ToolsEmailMaskerApp', (ToolsEmailMaskerApp, App, Backbone, Marionette, $, _) ->

  class ToolsEmailMaskerApp.Router extends App.Routers.Base

    appRoutes:
      'tools/email_masker' : 'newMask'

  API =

    newMask: (region) ->
      return App.execute 'tools:list', 'Email Masker', { action: 'newMask' } if not region

      new ToolsEmailMaskerApp.New.Controller
        region: region


  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Email Masker'

    action = options?.action
    action ?= 'newMask'

    if action is 'newMask'
      App.navigate '/tools/email_masker'
      API.newMask region


  ToolsEmailMaskerApp.on 'start', ->
    new ToolsEmailMaskerApp.Router
      controller: API
