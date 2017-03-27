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
          name:     'nc_username_eq'
          label:    'Username'
        ]
      ]


  class List.RequestHeader extends App.Views.ItemView
    template: 'legal_cfc_requests/list/_header'

    triggers:
      'click .edit-request'    : 'edit:clicked'
      'click .verify-request'  : 'verify:clicked'
      'click .process-request' : 'process:clicked'

    modelEvents:
      'change' : 'render'


  class List.MoreInfo extends App.Views.ItemView
    template: 'legal_cfc_requests/list/_more_info'

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


  class List.Request extends App.Views.LayoutView
    template: 'legal_cfc_requests/list/request'

    tagName:  'li'

    regions:
      headerRegion:    '.header'
      moreInfoRegion:  '.more-info'
      relationsRegion: '.relations'

    triggers:
      'click .header' : 'toggle:clicked'

    onShow: ->
      headerView = new List.RequestHeader model: @model
      @headerRegion.show headerView

      moreInfoView = new List.MoreInfo model: @model
      @moreInfoRegion.show moreInfoView

      relationsView = new List.Relations model: @model
      @relationsRegion.show relationsView

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
