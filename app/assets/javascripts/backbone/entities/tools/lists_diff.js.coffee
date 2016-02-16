@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.ListsDiff extends App.Entities.Model
    urlRoot: -> Routes.tools_lists_diffs_path()
    
    
  API =
    
    newListsDiff: (attrs) ->
      new Entities.ListsDiff attrs
      
  App.reqres.setHandler 'lists:diff:entity', (attrs = {}) ->
    API.newListsDiff attrs