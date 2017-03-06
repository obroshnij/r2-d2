@Artoo.module 'LegalNcUsersApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'legal_nc_users/list/layout'
    
    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      ncUsersRegion:    '#users-region'
      paginationRegion: '#pagination-region'


  class List.Panel extends App.Views.ItemView
    template: 'legal_nc_users/list/panel'

    triggers:
      'click a' : 'new:legal:nc:user:clicked'

    serializeData: ->
      canCreate: App.ability.can 'create', 'NcUser'

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
        ,
          name:     'status_ids_arr_cont'
          label:    'Has status'
          tagName:  'select'
          options:  @getStatuses()
        ]
      ]

    getStatuses: -> App.entities.nc_users_statuses


  class List.NcUserView extends App.Views.ItemView
    template: 'legal_nc_users/list/_user'

    tagName: 'li'

    modelEvents:
      'change' : 'render'

    triggers:
      'click .show-nc-user'   : 'show:clicked'

    @include 'HasDropdowns'


  class List.NcUsersView extends App.Views.CompositeView
    template: 'legal_nc_users/list/users'

    childView:          List.NcUserView
    childViewContainer: 'ul'