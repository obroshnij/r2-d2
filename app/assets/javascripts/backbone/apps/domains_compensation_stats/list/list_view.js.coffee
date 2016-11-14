@Artoo.module 'DomainsCompensationStatsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'domains_compensation_stats/list/layout'

    regions:
      panelRegion:           '#panel-region'
      searchRegion:          '#search-region'
      compensationsRegion:   '#stats-region'

  class List.Panel extends App.Views.ItemView
    template: 'domains_compensation_stats/list/panel'

  class List.StatView extends App.Views.ItemView
    template: 'domains_compensation_stats/list/_stat'

    tagName: 'li'

  class List.StatsView extends App.Views.CompositeView
    template: 'domains_compensation_stats/list/stats'

    childView:          List.StatsView
    childViewContainer: 'ul'


  class List.SearchSchema extends Marionette.Object

    form:
      buttons:
        primary:   'Search'
        cancel:    false
        placement: 'left'
      syncingType: 'buttons'
      focusFirstInput: false
      search: true

    schema: ->
      [
        legend:    'Filters'
        isCompact: true

        fields: [
          name:     'date_range'
          label:    'Date Range'
          type:     'date_range_picker'
        ]
      ]
