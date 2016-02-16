@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.DataSearch extends App.Entities.Model
    urlRoot: -> Routes.tools_data_searches_path()
    
    objectTypes:
      domain:        'Domain Names'
      host:          'Host Names'
      tld:           'TLDs'
      ip_v4:         'IPv4 Addresses'
      email:         'Email Addresses'
      kayako_ticket: 'Kayako Ticket IDs'
    
    mutators:
      
      objectTypeName: ->
        @objectTypes[@get('object_type')] if @get('object_type')
    
    
  API =
    
    newDataSearch: (attrs) ->
      new Entities.DataSearch attrs
      
  App.reqres.setHandler 'data:search:entity', (attrs = {}) ->
    API.newDataSearch attrs