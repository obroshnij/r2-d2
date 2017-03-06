@Artoo.module 'LegalNcUsersApp', (LegalNcUsersApp, App, Backbone, Marionette, $, _) ->

  class LegalNcUsersApp.Router extends App.Routers.Base

    appRoutes:
      'legal/nc_users'      : 'list'
      'legal/nc_users/:id'  : 'show'

  API =

    list: (region) ->
      return App.execute 'legal:list', 'Namecheap Users New', { action: 'list' } if not region

      new LegalNcUsersApp.List.Controller
        region: region

    show: (id, region) ->
      return App.execute 'legal:list', 'Namecheap Users New', { action: 'show', id: id } if not region

      new LegalNcUsersApp.Show.Controller
        region: region
        id:     id

    new: (region) ->
      new LegalNcUsersApp.New.Controller
        region: region

  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'Namecheap Users New'
    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/legal/nc_users'
      API.list region

    if action is 'show'
      App.navigate "/legal/nc_users/#{options.id}"
      API.show options.id, region


  App.vent.on 'show:nc:users:clicked', (ncUser) ->
    API.show ncUser.id

  App.vent.on 'new:legal:nc:user:clicked', ->
    API.new App.modalRegion

  LegalNcUsersApp.on 'start', ->
    new LegalNcUsersApp.Router
      controller: API
      resource:   'LaTool'
