@Artoo.module 'LegalRblsListApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'legal_rbls_list/list/layout'
    
    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      rblsRegion:       '#rbls-region'
      paginationRegion: '#pagination-region'
      
  
  class List.Panel extends App.Views.ItemView
    template: 'legal_rbls_list/list/panel'
    
    
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
          name:  'name_cont'
          label: 'Name contains'
        ,
          name:  'url_cont'
          label: 'URL contains'
        ,
          name:    'rbl_status_id_eq'
          label:   'Status'
          tagName: 'select'
          options: @getStatuses()
        ]
      ]
      
    getStatuses: -> App.entities.legal.rbl_status
    
    
  class List.Rbl extends App.Views.ItemView
    template: 'legal_rbls_list/list/_rbl'
    
    tagName: 'li'
    
    triggers:
      'click .edit-rbl' : 'edit:clicked'
      
    modelEvents:
      'change' : 'render'
    
    
  class List.Rbls extends App.Views.CompositeView
    template:  'legal_rbls_list/list/rbls'
    
    childView:          List.Rbl
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