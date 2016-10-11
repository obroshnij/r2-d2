@Artoo.module 'LegalBulkCurlApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      curl = App.request 'bulk:curl:entity', options.id
      
      @layout = @getLayoutView()
      @listenTo @layout, 'show', =>
        @tableRegion curl
      
      @show @layout
      
    tableRegion: (curl) ->
      tableView = @getTableView curl
      
      App.execute 'when:synced', curl, =>
        @show tableView, region: @layout.tableRegion
      
    getTableView: (curl) ->
      new Show.Table
        model: curl
      
    getLayoutView: ->
      new Show.Layout