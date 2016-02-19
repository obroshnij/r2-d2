@Artoo.module 'UserManagementApp', (UserManagementApp, App, Backbone, Marionette, $, _) ->
  
  class UserManagementApp.Router extends App.Routers.Base
    
    appRoutes:
      'user_management' : 'list'
  
  
  API =
    
    list: (nav, action) ->
      App.vent.trigger 'nav:select', 'User Management'
      new UserManagementApp.List.Controller
        nav:    nav
        action: action
  
  
  App.commands.setHandler 'user:management:list', (nav, action) ->
    API.list nav, action
  
  
  UserManagementApp.on 'start', ->
    new UserManagementApp.Router
      controller: API
      auth:       false