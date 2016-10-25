@Artoo.module 'DomainsCompensationStatsApp', (DomainsCompensationStatsApp, App, Backbone, Marionette, $, _) ->

  class DomainsCompensationStatsApp.Router extends App.Routers.Base

    appRoutes:
      'domains-general/compensation/stats' : 'list'

  API =

    list: (region) ->
      return App.execute 'domains:list', 'Compensation Stats', { action: 'list' } if not region

      new DomainsCompensationStatsApp.List.Controller
        region: region


  App.vent.on 'domains:nav:selected', (nav, options, region) ->
    return if nav isnt 'Compensation Stats'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/domains-general/compensation/stats'
      API.list region


  DomainsCompensationStatsApp.on 'start', ->
    new DomainsCompensationStatsApp.Router
      controller: API
