@Artoo.module 'LegalBulkCurlApp', (LegalBulkCurlApp, App, Backbone, Marionette, $, _) ->

  class LegalBulkCurlApp.Router extends App.Routers.Base

    appRoutes:
      'legal/bulk_curl'      : 'list'
      'legal/bulk_curl/:id'  : 'show'

  API =

    list: (region) ->
      return App.execute 'legal:list', 'Bulk CURL', { action: 'list' } if not region

      new LegalBulkCurlApp.List.Controller
        region: region

    show: (id, region) ->
      return App.execute 'legal:list', 'Bulk CURL', { action: 'show', id: id } if not region

      new LegalBulkCurlApp.Show.Controller
        region: region
        id:     id

  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'Bulk CURL'
    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/legal/bulk_curl'
      API.list region

    if action is 'show'
      App.navigate "/legal/bulk_curl/#{options.id}"
      API.show options.id, region


  App.vent.on 'show:bulk:curl:request:clicked', (request) ->
    API.show request.id

  LegalBulkCurlApp.on 'start', ->
    new LegalBulkCurlApp.Router
      controller: API
      resource:   'LaTool'
