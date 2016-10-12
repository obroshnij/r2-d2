@Artoo.module 'DomainsCompensationApp', (DomainsCompensationApp, App, Backbone, Marionette, $, _) ->

  class DomainsCompensationApp.Router extends App.Routers.Base

    appRoutes:
      'domains-general/compensation'          : 'list'
      'domains-general/compensation/new'      : 'newCompensation'
      'domains-general/compensation/:id/edit' : 'edit'

  API =

    list: (region) ->
      return App.execute 'domains:list', 'Compensation System', { action: 'list' } if not region

      new DomainsCompensationApp.List.Controller
        region: region

    newCompensation: (region) ->
      return App.execute 'domains:list', 'Compensation System', { action: 'newCompensation' } if not region

      new DomainsCompensationApp.New.Controller
        region: region

    edit: (id, region) ->
      return App.execute 'domains:list', 'Compensation System', { action: 'edit', id: id } if not region

      new DomainsCompensationApp.New.Controller
        region: region
        id:     id


  App.vent.on 'domains:nav:selected', (nav, options, region) ->
    return if nav isnt 'Compensation System'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/domains-general/compensation'
      API.list region

    if action is 'newCompensation'
      App.navigate '/domains-general/compensation/new'
      API.newCompensation region

    if action is 'edit'
      App.navigate "domains-general/compensation/#{options.id}/edit"
      API.edit options.id, region


  App.vent.on 'new:compensation:clicked', ->
    API.newCompensation()

  App.vent.on 'new:domains:compensation:cancelled', ->
    API.list()

  App.vent.on 'domains:compensation:created', (compensation) ->
    API.list()

  App.vent.on 'edit:compensation:clicked', (compensation) ->
    API.edit compensation.id


  DomainsCompensationApp.on 'start', ->
    new DomainsCompensationApp.Router
      controller: API
      resource:   'Domains::Compensation'
