@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  _.extend App,
  
    navigate: (route, options = {}) ->
      Backbone.history.navigate route, options
    
    getCurrentRoute: ->
      fragment = Backbone.history.fragment
      if _.isEmpty(fragment) then null else fragment
      
    startHistory: ->
      if Backbone.history
        found = Backbone.history.start()
        App.vent.trigger 'page:not:found' unless found