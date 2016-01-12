@Artoo.module 'ToolsApp.List', (List, App, Backbone, Marionette, $, _) ->
        
  class List.Layout extends App.Views.LayoutView
    template: 'tools/list/list_layout'
    
    regions:
      titleRegion:       '#title-region'
      breadcrumbsRegion: '#breadcrumbs-region'
      toolsNavsRegion:   '#tools-navs-region'
      articleRegion:     '#article-region'
      
  
  class List.Title extends App.Views.ItemView
    template: 'tools/list/title'
  
  
  class List.Breadcrumbs extends App.Views.ItemView
    template: 'tools/list/breadcrumbs'
    
    collectionEvents:
      'select:one' : 'render'
      
    serializeData: ->
      'toolsNav' : @collection.selected?.get('name')
      
      
  class List.Nav extends App.Views.ItemView
    template: 'tools/list/_nav'
    tagName:  'li'
    
    events:
      'click a' : 'select'
    
    @include 'Selectable'
  
  
  class List.Navs extends App.Views.CollectionView
    tagName:   'ul'
    childView: List.Nav
    
    attributes:
      class: 'menu vertical'
      id:    'side-nav'