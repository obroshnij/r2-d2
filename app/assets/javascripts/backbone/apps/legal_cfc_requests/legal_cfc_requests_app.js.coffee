@Artoo.module 'LegalCfcRequestsApp', (LegalCfcRequestsApp, App, Backbone, Marionette, $, _) ->

  class LegalCfcRequestsApp.Router extends App.Routers.Base

    appRoutes:
      'legal/cfc_requests'             : 'list'
      'legal/cfc_requests/new'         : 'newRequest'
      'legal/cfc_requests/:id/edit'    : 'edit'
      'legal/cfc_requests/:id/process' : 'process'

  API =

    list: (region) ->
      return App.execute 'legal:list', 'CFC Requests', { action: 'list' } if not region

      new LegalCfcRequestsApp.List.Controller
        region: region

    newRequest: (region) ->
      return App.execute 'legal:list', 'CFC Requests', { action: 'newRequest' } if not region

      new LegalCfcRequestsApp.New.Controller
        region: region

    edit: (id, region) ->
      return App.execute 'legal:list', 'CFC Requests', { action: 'edit', id: id } if not region

      new LegalCfcRequestsApp.New.Controller
        region: region
        id:     id

    verify: (request) ->
      new LegalCfcRequestsApp.Verify.Controller
        region:  App.modalRegion
        request: request

    process: (id, region) ->
      return App.execute 'legal:list', 'CFC Requests', { action: 'process', id: id } if not region

      new LegalCfcRequestsApp.Process.Controller
        region: region
        id:     id


  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'CFC Requests'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/legal/cfc_requests'
      API.list region

    if action is 'newRequest'
      App.navigate '/legal/cfc_requests/new'
      API.newRequest region

    if action is 'edit'
      App.navigate "/legal/cfc_requests/#{options.id}/edit"
      API.edit options.id, region

    if action is 'process'
      App.navigate "/legal/cfc_requests/#{options.id}/process"
      API.process options.id, region


  App.vent.on 'submit:request:clicked', ->
    API.newRequest()

  App.vent.on 'new:cfc:request:cancelled', ->
    API.list()

  App.vent.on 'cfc:request:created', ->
    API.list()

  App.vent.on 'edit:cfc:request:clicked', (request) ->
    API.edit request.id

  App.vent.on 'verify:cfc:request:clicked', (request) ->
    API.verify request

  App.vent.on 'process:cfc:request:clicked', (request) ->
    API.process request.id


  LegalCfcRequestsApp.on 'start', ->
    new LegalCfcRequestsApp.Router
      controller: API
      resource:   'Legal::CfcRequest'
