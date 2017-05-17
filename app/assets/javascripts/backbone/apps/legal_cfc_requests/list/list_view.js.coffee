@Artoo.module 'LegalCfcRequestsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'legal_cfc_requests/list/layout'

    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      requestsRegion:   '#requests-region'
      paginationRegion: '#pagination-region'


  class List.Panel extends App.Views.ItemView
    template: 'legal_cfc_requests/list/panel'

    triggers:
      'click a' : 'submit:request:clicked'

    serializeData: ->
      canCreate: App.ability.can 'create', 'Legal::CfcRequest'


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
          name:     'nc_username_cont'
          label:    'Username contains'
        ,
          name:     'relations_username_eq'
          label:    'Username (related) equals'
        ,
          name:     'status_eq'
          label:    'Status'
          tagName:  'select'
          options:  [{ id: '0', name: 'New' }, { id: '1', name: 'Pending Verification' }, { id: '2', name: 'Processed' }]
        ,
          name:      'request_type_eq'
          label:     'Request Type'
          tagName:   'select'
          options:   [{ id: '0', name: 'Check for Fraud' }, { id: '1', name: 'Find Relations' }]
        ,
          name:      'processed_by_id_eq'
          label:     'Processed by'
          tagName:   'select'
          options:   App.entities.legal.cfc_requests.processed_by
        ,
          name:      'submitted_by_id_eq'
          label:     'Submitted by'
          tagName:   'select'
          options:   App.entities.legal.cfc_requests.submitted_by
        ,
          name:      'created_at_datetime_between'
          label:     'Created on'
          type:      'date_range_picker'
        ,
          name:      'processed_at_datetime_between'
          label:     'Processed on'
          type:      'date_range_picker'
        ]
      ]


  class List.RequestHeader extends App.Views.ItemView
    template: 'legal_cfc_requests/list/_header'

    triggers:
      'click .edit-request'    : 'edit:clicked'
      'click .verify-request'  : 'verify:clicked'
      'click .process-request' : 'process:clicked'

    events:
      'click .dropdown-pane' : 'doNothing'

    modelEvents:
      'change' : 'render'

    doNothing: (event) ->
      event.preventDefault()
      event.stopPropagation()

    serializeData: ->
      data = super
      data.canEdit    = App.ability.can 'create',  @model
      data.canVerify  = App.ability.can 'process', @model
      data.canProcess = App.ability.can 'process', @model
      data

    @include 'HasDropdowns'


  class List.MoreInfo extends App.Views.ItemView
    template: 'legal_cfc_requests/list/_more_info'

    modelEvents:
      'change' : 'render'

    @include 'HasEditableFields'


  class List.ProcessingInfo extends App.Views.ItemView
    template: 'legal_cfc_requests/list/_processing_info'

    modelEvents:
      'change' : 'render'

    @include 'HasEditableFields'


  class List.Relations extends App.Views.ItemView
    template: 'legal_cfc_requests/list/_relations'

    modelEvents:
      'change' : 'render'

    templateHelpers:

      relationNames: (ids) ->
        ids.map (id) =>
          App.entities.legal.user_relation_types
          .find (r) => r.id is id
          .name
        .join(', ')


  class List.PreviousRelations extends List.Relations
    template: 'legal_cfc_requests/list/_previous_relations'


  class List.Request extends App.Views.LayoutView
    template: 'legal_cfc_requests/list/request'

    tagName:  'li'

    regions:
      headerRegion:            '.header'
      moreInfoRegion:          '.more-info'
      relationsRegion:         '.relations'
      previousRelationsRegion: '.previous-relations'
      processingInfoRegion:    '.processing-info'

    triggers:
      'click .header' : 'toggle:clicked'

    onShow: ->
      headerView = new List.RequestHeader model: @model
      @headerRegion.show headerView

      moreInfoView = new List.MoreInfo model: @model
      @moreInfoRegion.show moreInfoView

      processingInfoView = new List.ProcessingInfo model: @model
      @processingInfoRegion.show processingInfoView

      relationsView = new List.Relations model: @model
      @relationsRegion.show relationsView

      previousRelationsView = new List.PreviousRelations model: @model
      @previousRelationsRegion.show previousRelationsView

    onToggleClicked: ->
      @$el.toggleClass 'expanded'
      @$('.expand').toggle 200

      @$('.header a.toggle').toggleClass      'expanded'
      @$('.header a.toggle icon').toggleClass 'fa-rotate-180'

    onChildviewEditClicked: (child, options) ->
      @trigger 'edit:cfc:request:clicked', options

    onChildviewVerifyClicked: (child, options) ->
      @trigger 'verify:cfc:request:clicked', options

    onChildviewProcessClicked: (child, options) ->
      @trigger 'process:cfc:request:clicked', options


  class List.Requests extends App.Views.CompositeView
    template: 'legal_cfc_requests/list/requests'

    childView:          List.Request
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
