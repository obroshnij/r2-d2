@Artoo.module 'LegalBulkCurlApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Layout extends App.Views.LayoutView
    template: 'legal_bulk_curl/show/layout'
    
    regions:
      tableRegion:      '#requests-table-region'
  
  
  class Show.Table extends App.Views.ItemView
    template: 'legal_bulk_curl/show/table'
    modelEvents:
      'change' : 'render'
      
    onDomRefresh: ->
      @$('table').tablesorter()