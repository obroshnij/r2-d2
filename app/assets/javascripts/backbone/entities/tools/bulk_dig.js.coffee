@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BulkDig extends App.Entities.Model
    urlRoot: -> Routes.tools_bulk_digs_path()
    
  
  API =
    
    newBulkDig: (attrs) ->
      new Entities.BulkDig attrs
      
  
  App.reqres.setHandler 'bulk:dig:entity', (attrs = {}) ->
    API.newBulkDig attrs