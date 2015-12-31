@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.WhoisLookup extends App.Entities.Model
    urlRoot: -> Routes.tools_whois_lookups_path()
    
    
  API =
    
    newWhoisLookup: (attrs) ->
      new Entities.WhoisLookup attrs
      
  App.reqres.setHandler 'whois:lookup:entity', (attrs = {}) ->
    API.newWhoisLookup attrs