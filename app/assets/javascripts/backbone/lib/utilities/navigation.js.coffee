@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  _.extend App,
  
    navigate: (route, options = {}) ->
      route = '#' + route if route.charAt(0) is '/'
      Backbone.history.navigate route, options
    
    getCurrentRoute: ->
      fragment = Backbone.history.fragment
      if _.isEmpty(fragment) then null else fragment
      
    startHistory: ->
      if Backbone.history
        Backbone.history.start()