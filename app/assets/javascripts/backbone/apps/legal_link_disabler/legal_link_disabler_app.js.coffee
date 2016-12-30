@Artoo.module 'LegalLinkDisablerApp', (LegalLinkDisablerApp, App, Backbone, Marionette, $, _) ->
  class LegalLinkDisablerApp.Router extends App.Routers.Base

    appRoutes:
      'legal/link_disabler' : 'checkLink'

  API =

    checkLink: (region) ->
      return App.execute 'legal:list', 'Link Disabler', { action: 'checkLink' } if not region

      new LegalLinkDisablerApp.New.Controller
        region: region


  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'Link Disabler'

    action = options?.action
    action ?= 'checkLink'

    if action is 'checkLink'
      App.navigate '/legal/link_disabler'
      API.checkLink region


  LegalLinkDisablerApp.on 'start', ->
    new LegalLinkDisablerApp.Router
      controller: API
      resource:   'LaTool'