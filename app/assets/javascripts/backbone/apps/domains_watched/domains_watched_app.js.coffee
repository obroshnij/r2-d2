@Artoo.module 'DomainsWatchedApp', (DomainsWatchedApp, App, Backbone, Marionette, $, _) ->

  class DomainsWatchedApp.Router extends App.Routers.Base

    appRoutes:
      'domains-general/watched' : 'list'

  API =

    list: (region) ->
      return App.execute 'domains:list', 'Watched Domains', 'list' if not region

      new DomainsWatchedApp.List.Controller
        region: region

    newDomain: (domains) ->
      new DomainsWatchedApp.New.Controller
        region:  App.modalRegion
        domains: domains


  App.vent.on 'domains:nav:selected', (nav, options, region) ->
    return if nav isnt 'Watched Domains'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/domains-general/watched'
      API.list region


  App.vent.on 'new:watched:domain:clicked', (domains) ->
    API.newDomain domains


  DomainsWatchedApp.on 'start', ->
    new DomainsWatchedApp.Router
      controller: API
