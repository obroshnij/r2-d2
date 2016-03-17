@Artoo.module 'ToolsBulkWhoisApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      lookup = App.request 'bulk:whois:lookup:entity', options.id
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @attributesRegion lookup
        @tableRegion lookup
      
      @show @layout
      
    attributesRegion: (lookup) ->
      attributesView = @getAttributesView lookup
      
      @show attributesView, region: @layout.attributesRegion, loading: true
      
    tableRegion: (lookup) ->
      tableView = @getTableView lookup
      
      @listenTo tableView, 'show:raw:whois', (domain) ->
        record = _.find lookup.get('whois_data'), (obj) -> obj['domain_name'] is domain
        App.vent.trigger 'show:raw:whois', record
      
      App.execute 'when:synced', lookup, =>
        @show tableView, region: @layout.tableRegion
      
    getAttributesView: (lookup) ->
      new Show.Attributes
        model: lookup
      
    getTableView: (lookup) ->
      new Show.Table
        model: lookup
      
    getLayoutView: ->
      new Show.Layout