@Artoo.module 'LegalRblsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'legal_rbls/list/layout'

    regions:
      navRegion:     '#nav-region'
      contentRegion: '#content-region'


  class List.Nav extends App.Views.ItemView
    template: 'legal_rbls/list/nav'

    tagName: 'li'

    events:
      'click a' : 'select'

    @include 'Selectable'


  class List.Navigation extends App.Views.CompositeView
    template: 'legal_rbls/list/navigation'

    childView:          List.Nav
    childViewContainer: 'ul'
