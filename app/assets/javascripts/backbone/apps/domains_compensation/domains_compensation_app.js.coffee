@Artoo.module 'DomainsCompensationApp', (DomainsCompensationApp, App, Backbone, Marionette, $, _) ->

  class DomainsCompensationApp.Router extends App.Routers.Base

    appRoutes:
      'domains-general/compensation'     : 'list'
      'domains-general/compensation/new' : 'newCompensation'

  API =

    list: (region) ->
      return App.execute 'domains:list', 'Compensation System', 'list' if not region

      new DomainsCompensationApp.List.Controller
        region: region

    newCompensation: (region) ->
      return App.execute 'domains:list', 'Compensation System', 'newCompensation' if not region

      new DomainsCompensationApp.New.Controller
        region: region


  App.vent.on 'domains:nav:selected', (nav, action, region) ->
    return if nav isnt 'Compensation System'

    action ?= 'list'

    if action is 'list'
      App.navigate '/domains-general/compensation'
      API.list region

    if action is 'newCompensation'
      App.navigate '/domains-general/compensation/new'
      API.newCompensation region


  App.vent.on 'new:compensation:clicked', ->
    API.newCompensation()


  DomainsCompensationApp.on 'start', ->
    new DomainsCompensationApp.Router
      controller: API
      resource:   'Domains::Compensation'
