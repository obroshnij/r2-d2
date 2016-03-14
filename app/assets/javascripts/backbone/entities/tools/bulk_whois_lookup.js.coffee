@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BulkWhoisLookup extends App.Entities.Model
    urlRoot: -> Routes.tools_bulk_whois_lookups_path()
    
    
  API =
    
    newBulkWhoisLookup: (attrs) ->
      new Entities.BulkWhoisLookup attrs
      
  App.reqres.setHandler 'new:bulk:whois:lookup:entity', (attrs = {}) ->
    API.newBulkWhoisLookup attrs