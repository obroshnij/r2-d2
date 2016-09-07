@Artoo.module 'LegalPdfierApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'legal_pdfier/list/layout'

    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      reportsRegion:    '#reports-region'
      paginationRegion: '#pagination-region'


  class List.Panel extends App.Views.ItemView
    template: 'legal_pdfier/list/panel'

    triggers:
      'click a.new-report' : 'new:pdf:report:clicked'

    serializeData: ->
      canCreate: App.ability.can 'create', 'Legal::PdfReport'


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
          name:     'username_cont'
          label:    'Username contains'
        ]
      ]


  class List.Report extends App.Views.ItemView
    template: 'legal_pdfier/list/_report'

    tagName: 'li'

    triggers:
      'click .show-report' : 'show:report:clicked'


  class List.Reports extends App.Views.CompositeView
    template: 'legal_pdfier/list/reports'

    childView:          List.Report
    childViewContainer: 'ul'

    collectionEvents:
      'collection:sync:start' : 'syncStart'
      'collection:sync:stop'  : 'syncStop'

    syncStart: ->
      @addOpacityWrapper()

    syncStop: ->
      @addOpacityWrapper false

    onDestroy: ->
      @addOpacityWrapper false
