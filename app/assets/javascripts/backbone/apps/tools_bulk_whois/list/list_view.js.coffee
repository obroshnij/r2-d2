@Artoo.module 'ToolsBulkWhoisApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'tools_bulk_whois/list/layout'
    
    regions:
      newLookupRegion:  '#new-lookup-region'
      lookupsRegion:    '#lookups-region'
      paginationRegion: '#pagination-region'

      
  class List.NewLookupSchema extends Marionette.Object
    
    form:
      buttons:
        primary: 'Submit'
        cancel:  false
    
    schema:
      [
        {
          legend: 'Bulk whois lookup'
          fields: [
            name:    'query'
            label:   'Domain Names'
            tagName: 'textarea'
            hint:    "Bulk whois lookups are performed one by one in the background due to whois servers' limitations"
          ]
        }
      ]
      
      
  class List.LookupView extends App.Views.ItemView
    template: 'tools_bulk_whois/list/_lookup'
        
    tagName: 'li'
    
    modelEvents:
      'change' : 'render'
    
    triggers:
      'click .delete-lookup' : 'delete:clicked'
      'click .show-lookup'   : 'show:clicked'
      
      
  class List.LookupsView extends App.Views.CompositeView
    template: 'tools_bulk_whois/list/lookups'
    
    childView:          List.LookupView
    childViewContainer: 'ul'