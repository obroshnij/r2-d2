@Artoo.module "LegalApp.List", (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'legal/list/list_layout'
    
    regions:
      titleRegion:       '#title-region'
      breadcrumbsRegion: '#breadcrumbs-region'
      legalNavsRegion:   '#legal-navs-region'
      articleRegion:     '#article-region'
      
    
  class List.Title extends App.Views.ItemView
    template: 'legal/list/title'
      
  
  class List.Breadcrumbs extends App.Views.ItemView
    template: 'legal/list/breadcrumbs'
    
    collectionEvents:
      'select:one' : 'render'
      
    serializeData: ->
      'legalNav' : @collection.selected?.get('name')
  
  
  class List.Nav extends App.Views.ItemView
    template: 'legal/list/_nav'
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