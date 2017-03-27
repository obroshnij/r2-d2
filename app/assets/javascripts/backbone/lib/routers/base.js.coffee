@Artoo.module 'Routers', (Routers, App, Backbone, Marionette, $, _) ->

  class Routers.Base extends Marionette.AppRouter

    constructor: (options = {}) ->
      _.defaults options,
        auth:     true
        resource: false

      { @auth, @resource } = options

      super

    before: (route, params) ->
      @checkAuthentication() and @checkAuthorization(route)

    checkAuthentication: ->
      return true if @auth is false

      currentUser = App.request 'get:current:user'

      unless currentUser
        App.vent.trigger 'auth:required'
        return false

      true

    checkAuthorization: (route) ->
      return true if @resource is false

      action  = @_getAction(route)
      ability = App.request 'get:current:ability'

      unless ability.can(action, @resource)
        App.vent.trigger 'access:denied'
        return false

      true

    _getAction: (route) ->
      @_getActionAlias @appRoutes[route]

    _getActionAlias: (action) ->
      return 'index'  if action is 'list'
      return 'show'   if action is 'show'
      return 'update' if action is 'edit'
      return 'create' if /^new/.test action
      action
