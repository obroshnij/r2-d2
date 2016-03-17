@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BulkWhoisLookup extends App.Entities.Model
    urlRoot: -> Routes.tools_bulk_whois_lookups_path()
    
    defaults:
      selectedAttributes: ['status', 'nameservers']
    
    mutators:
      
      availableAttributes: ->
        _.chain(@get('whois_data')).map((obj) -> _.keys(obj['whois_attributes'])).flatten().uniq().value()
    
  
  class Entities.BulkWhoisLookupsCollection extends App.Entities.Collection
    model: Entities.BulkWhoisLookup
    
    url: -> Routes.tools_bulk_whois_lookups_path()
    
    
  API =
    
    newBulkWhoisLookup: (attrs) ->
      new Entities.BulkWhoisLookup attrs
      
    newBulkWhoisLookupsCollection: ->
      lookups = new Entities.BulkWhoisLookupsCollection
      lookups.fetch()
      lookups
      
    getBulkWhoisLookup: (id) ->
      lookup = new Entities.BulkWhoisLookup id: id
      lookup.fetch()
      lookup
      
  App.reqres.setHandler 'new:bulk:whois:lookup:entity', (attrs = {}) ->
    API.newBulkWhoisLookup attrs
    
  App.reqres.setHandler 'bulk:whois:lookup:entities', ->
    API.newBulkWhoisLookupsCollection()
    
  App.reqres.setHandler 'bulk:whois:lookup:entity', (id) ->
    API.getBulkWhoisLookup id