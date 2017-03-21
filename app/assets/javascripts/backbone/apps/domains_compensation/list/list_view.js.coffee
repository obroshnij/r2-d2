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
          name:     'affected_product_id_eq'
          label:    'Affected Service'
          tagName:  'select'
          options:  @getAffectedProducts()
        ,
          name:     'product_compensated_id_eq'
          label:    'Service Compensated'
          tagName:  'select'
          options:  @getProductsCompensated()
        ,
          name:     'submitted_by_id_eq'
          label:    'Submitted by'
          tagName:  'select'
          options:  @getSubmittedBy()
        ,
          name:     'department_eq'
          label:    'Department'
          tagName:  'select'
          options:  @getDepartments()
        ,
          name:     'reference_id_cont'
          label:    'Reference ID'
        ,
          name:     'created_at_datetime_between'
          label:    'Submitted on'
          type:     'date_range_picker'
        ]
      ]

    getSubmittedBy: ->
      App.entities.domains.compensation.submitted_by

    getDepartments: ->
      App.entities.domains.compensation.departments

    getAffectedProducts: ->
      App.entities.domains.compensation.affected_product

    getProductsCompensated: ->
      App.entities.domains.compensation.product


  class List.CompensationHeader extends App.Views.ItemView
    template: 'domains_compensation/list/_header'

    triggers:
      'click .edit-compensation'  : 'edit:clicked'
      'click .check-compensation' : 'check:clicked'

    serializeData: ->
      data = super
      data.canEdit  = App.ability.can('update',   @model)
      data.canCheck = App.ability.can('qa_check', @model)
      data

    modelEvents:
      change: 'render'


  class List.AdditionalInfo extends App.Views.ItemView
    template: 'domains_compensation/list/_additional_info'

    modelEvents:
      change: 'render'

    @include 'HasEditableFields'


  class List.QaInfo extends App.Views.ItemView
    template: 'domains_compensation/list/_qa_info'

    modelEvents:
      change: 'render'

    @include 'HasEditableFields'


  class List.Compensation extends App.Views.LayoutView
    template: 'domains_compensation/list/compensation'

    tagName:  'li'

    regions:
      headerRegion:         '.header'
      additionalInfoRegion: '.additional-info'
      qaInfoRegion:         '.qa-info'

    triggers:
      'click .header' : 'toggle:clicked'

    onShow: ->
      headerView = new List.CompensationHeader model: @model
      @headerRegion.show headerView

      additionalInfoView = new List.AdditionalInfo model: @model
      @additionalInfoRegion.show additionalInfoView

      qaInfoView = new List.QaInfo model: @model
      @qaInfoRegion.show qaInfoView

    onToggleClicked: ->
      @$el.toggleClass 'expanded'
      @$('.expand').toggle 200

      @$('.header a.toggle').toggleClass      'expanded'
      @$('.header a.toggle icon').toggleClass 'fa-rotate-180'

    onChildviewEditClicked: (child, options) ->
      @trigger 'edit:compensation:clicked', options

    onChildviewCheckClicked: (child, options) ->
      @trigger 'check:compensation:clicked', options


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
