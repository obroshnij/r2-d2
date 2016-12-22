@Artoo.module 'DomainsCompensationStatsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.LayoutView
    template: 'domains_compensation_stats/show/layout'

    regions:
      panelRegion:  '#panel-region'
      searchRegion: '#search-region'
      statsRegion:  '#stats-region'


  class Show.Panel extends App.Views.ItemView
    template: 'domains_compensation_stats/show/panel'

  class Show.StatsView extends App.Views.CompositeView
    template: 'domains_compensation_stats/show/stats'

    events: {
      'click .product-element' : 'toggleClicked'
    }

    modelEvents:
      'change' : 'render'

    toggleClicked: (e)->
      $element = $(e.currentTarget)

      unless $element.hasClass('detailed-empty')
        $detailed = $element.next().next()
        $detailed.toggleClass                      'expanded'
        $element.find('a.toggle').toggleClass      'expanded'
        $element.find('a.toggle icon').toggleClass 'fa-rotate-180'

    onDomRefresh: ->
      new Foundation.Tabs @$('#compensation-reports')

    onDestroy: ->
      @$('#compensation-reports').foundation 'destroy'


  class Show.SearchSchema extends Marionette.Object

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
