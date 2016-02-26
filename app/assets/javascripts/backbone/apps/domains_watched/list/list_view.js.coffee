@Artoo.module 'DomainsWatchedApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'domains_watched/list/layout'
    
    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      domainsRegion:    '#domains-region'
      paginationRegion: '#pagination-region'
      
  
  class List.Panel extends App.Views.ItemView
    template: 'domains_watched/list/panel'
    
    triggers:
      'click a' : 'new:watched:domain:clicked'
    
  
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
          name:     'name_cont'
          label:    'Name contains'
        ,
          name:     'comment_cont'
          label:    'Comments contain'
        ]
      ]
      
      
  class List.DomainView extends App.Views.ItemView
    template: 'domains_watched/list/_domain'
    
    tagName: 'li'
    
    triggers:
      'click .delete-domain' : 'delete:clicked'
    
  
  class List.DomainsView extends App.Views.CompositeView
    template: 'domains_watched/list/domains'
    
    childView:          List.DomainView
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