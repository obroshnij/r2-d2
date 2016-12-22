@Artoo.module 'LegalBulkCurlApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'legal_bulk_curl/list/layout'
    
    regions:
      newRequestRegion:  '#new-request-region'
      requestsRegion:    '#requests-region'
      paginationRegion: '#pagination-region'

      
  class List.NewRequestSchema extends Marionette.Object
    
    form:
      buttons:
        primary: 'Submit'
        cancel:  false
    
    schema:
      [
        {
          legend: 'Bulk curl'
          fields: [
            name:    'urls'
            label:   'URLs'
            tagName: 'textarea'
            hint:    'Bulk curl requests are performed one by one in the background'
          ]
        }
      ]


  class List.RequestView extends App.Views.ItemView
    template: 'legal_bulk_curl/list/_request'

    tagName: 'li'

    modelEvents:
      'change' : 'render'

    triggers:
      'click .show-request'   : 'show:clicked'

    @include 'HasDropdowns'


  class List.RequestsView extends App.Views.CompositeView
    template: 'legal_bulk_curl/list/requests'

    childView:          List.RequestView
    childViewContainer: 'ul'