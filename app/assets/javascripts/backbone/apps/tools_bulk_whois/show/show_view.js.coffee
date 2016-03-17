@Artoo.module 'ToolsBulkWhoisApp.Show', (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Layout extends App.Views.LayoutView
    template: 'tools_bulk_whois/show/layout'
    
    regions:
      attributesRegion: '#attributes-region'
      tableRegion:      '#table-region'
      
  
  class Show.Attributes extends App.Views.ItemView
    template: 'tools_bulk_whois/show/attributes'
    
    events:
      'change input' : 'updateAttributes'
      
    updateAttributes: ->
      @model.set 'selectedAttributes', @$('input:checked').map (index, input) -> $(input).val()
  
  
  class Show.Table extends App.Views.ItemView
    template: 'tools_bulk_whois/show/table'
    
    modelEvents:
      'change' : 'render'