@Artoo.module 'UserManagementUsersApp', (UserManagementUsersApp, App, Backbone, Marionette, $, _) ->
  
  class UserManagementUsersApp.Router extends App.Routers.Base
    
    appRoutes:
      'user_management/users' : 'list'
      
  API =
    
    list: (region) ->
      return App.execute 'user:management:list', 'Users', 'list' if not region
      
      new UserManagementUsersApp.List.Controller
        region: region
        
        
  App.vent.on 'user:management:nav:selected', (nav, options, region) ->
    return if nav isnt 'Users'
    
    action = options?.action
    action ?= 'list'
      
    if action is 'list'
      App.navigate '/user_management/users'
      API.list region
  
  
  UserManagementUsersApp.on 'start', ->
    new UserManagementUsersApp.Router
      controller: API
      auth:       false