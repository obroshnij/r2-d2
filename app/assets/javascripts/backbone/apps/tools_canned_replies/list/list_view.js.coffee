@Artoo.module 'ToolsCannedRepliesApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'tools_canned_replies/list/layout'

    regions:
      navRegion:      '#replies-nav-region'
      contentRegion:  '#replies-content'

  class List.Nav extends App.Views.ItemView
    template: 'tools_canned_replies/list/_nav'

    tagName: 'li'

    events:
      'click a' : 'select'

    @include 'Selectable'

  class List.Navigation extends App.Views.CompositeView
    template: 'tools_canned_replies/list/_navigation'
    childView:          List.Nav
    childViewContainer: 'ul'
