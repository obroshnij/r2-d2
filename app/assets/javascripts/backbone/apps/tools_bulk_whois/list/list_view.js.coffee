@Artoo.module 'ToolsBulkWhoisApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'tools_bulk_whois/list/layout'
    
    regions:
      newLookupRegion: '#new-lookup-region'

      
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