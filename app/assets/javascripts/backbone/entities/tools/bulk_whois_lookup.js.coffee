@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BulkWhoisLookup extends App.Entities.Model
    urlRoot: -> Routes.tools_bulk_whois_lookups_path()
    
    defaults:
      selectedAttributes: ['status', 'nameservers']
      
    statusColorLookups: { 'Enqueued': 'secondary', 'In Progress': 'primary', 'Completed': 'success', 'Partially Failed': 'alert', 'Pending Retrial': 'warning' }
    
    mutators:
      
      availableAttributes: ->
        possible  = ['available', 'status', 'nameservers', 'creation_date', 'expiration_date', 'updated_date', 'registrar', 'registrant_contact', 'admin_contact', 'billing_contact', 'tech_contact']
        available = _.chain(@get('whois_data')).map((obj) -> _.keys(obj['whois_attributes'])).flatten().uniq().value()
        _.intersection possible, available
        
      statusColor: ->
        @statusColorLookups[@get('status')] if @get('status')
        
    retryFailed: (attributes = {}, options = {}) ->
      options.url = Routes.retry_tools_bulk_whois_lookup_path(@id)
      @save attributes, options
    
  
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