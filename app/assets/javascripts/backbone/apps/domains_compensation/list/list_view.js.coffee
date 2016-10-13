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

    serializeData: ->
      canCreate: App.ability.can 'create', 'Domains::Compensation'

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
          name:     'submitted_by_id_eq'
          label:    'Submitted by'
          tagName:  'select'
          options:  @getSubmittedBy()
        ]
      ]

    getSubmittedBy: ->
      App.entities.domains.compensation.submitted_by


  class List.Compensation extends App.Views.ItemView
    template: 'domains_compensation/list/compensation'

    tagName:  'li'

    triggers:
      'click .edit-compensation'  : 'edit:compensation:clicked'
      'click .check-compensation' : 'check:compensation:clicked'

    serializeData: ->
      data = super
      data.canEdit = App.ability.can 'update', @model
      data

    @include 'HasDropdowns'


  class List.Compensations extends App.Views.CompositeView
    template: 'domains_compensation/list/compensations'

    childView:          List.Compensation
    childViewContainer: 'ul'

    className: 'clearfix'

    collectionEvents:
      'collection:sync:start' : 'syncStart'
      'collection:sync:stop'  : 'syncStop'

    syncStart: ->
      @addOpacityWrapper()

    syncStop: ->
      @addOpacityWrapper false

    onDestroy: ->
      @addOpacityWrapper false
