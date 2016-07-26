@Artoo.module 'ToolsInternalDomainsApp', (ToolsInternalDomainsApp, App, Backbone, Marionette, $, _) ->

  class ToolsInternalDomainsApp.Router extends App.Routers.Base

    appRoutes:
      'tools/internal' : 'list'

  API =

    list: (region) ->
      return App.execute 'tools:list', 'Internal Domains', { action: 'list' } if not region

      new ToolsInternalDomainsApp.List.Controller
        region: region

    newDomain: (domains) ->
      new ToolsInternalDomainsApp.New.Controller
        region:  App.modalRegion
        domains: domains

    edit: (domain, domains) ->
      new ToolsInternalDomainsApp.New.Controller
        region:  App.modalRegion
        domains: domains
        domain:  domain


  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Internal Domains'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/tools/internal'
      API.list region

  App.vent.on 'new:internal:domain:clicked', (domains) ->
    API.newDomain domains

  App.vent.on 'edit:internal:domain:clicked', (domain, domains) ->
    API.edit domain, domains


  ToolsInternalDomainsApp.on 'start', ->
    new ToolsInternalDomainsApp.Router
      controller: API
