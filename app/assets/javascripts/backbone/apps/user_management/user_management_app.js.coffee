@Artoo.module 'UserManagementApp', (UserManagementApp, App, Backbone, Marionette, $, _) ->
  
  class UserManagementApp.Router extends App.Routers.Base
    
    appRoutes:
      'user_management' : 'list'
  
  
  API =
    
    list: (nav, options) ->
      App.vent.trigger 'nav:select', 'User Management'
      new UserManagementApp.List.Controller
        nav:     nav
        options: options
  
  
  App.commands.setHandler 'user:management:list', (nav, options) ->
    API.list nav, options
  
  
  UserManagementApp.on 'start', ->
    new UserManagementApp.Router
      controller: API