@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Collection extends Backbone.PageableCollection
    
    _entityType: 'collection'
        
    parseRecords: (resp) ->
      resp.items
    
    parseState: (resp, queryParams, state, options) ->
      resp.pagination
      
    search: (data) ->
      @ransack = data
      @getPage 1