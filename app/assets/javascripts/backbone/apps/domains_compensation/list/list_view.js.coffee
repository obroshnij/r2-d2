@Artoo.module 'DomainsCompensationApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'domains_compensation/list/layout'

    regions:
      panelRegion:         '#panel-region'
      searchRegion:        '#search-region'
      compensationsRegion: '#compensations-region'
      paginationRegion:    '#pagination-region'


  class List.Panel extends App.Views.ItemView
    template: 'domains_compensation/list/panel'

    triggers:
      'click a' : 'new:compensation:clicked'
