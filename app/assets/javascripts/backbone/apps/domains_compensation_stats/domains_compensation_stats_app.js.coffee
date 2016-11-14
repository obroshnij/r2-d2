@Artoo.module 'DomainsCompensationStatsApp', (DomainsCompensationStatsApp, App, Backbone, Marionette, $, _) ->

  class DomainsCompensationStatsApp.Router extends App.Routers.Base

    appRoutes:
      'domains-general/compensation/stats' : 'show'

  API =

    show: (region) ->
      return App.execute 'domains:list', 'Compensation Stats', { action: 'show' } if not region

      new DomainsCompensationStatsApp.Show.Controller
        region: region


  App.vent.on 'domains:nav:selected', (nav, options, region) ->
    return if nav isnt 'Compensation Stats'

    action = options?.action
    action ?= 'show'

    if action is 'show'
      App.navigate '/domains-general/compensation/stats'
      API.show region


  DomainsCompensationStatsApp.on 'start', ->
    new DomainsCompensationStatsApp.Router
      controller: API
      resource:   'Domains::Compensation::Statistic'
