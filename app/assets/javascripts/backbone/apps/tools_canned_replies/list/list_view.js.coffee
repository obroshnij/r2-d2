@Artoo.module 'ToolsCannedRepliesApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'tools_canned_replies/list/layout'

    regions:
      fileInput:    '#replies-file-input'
      repliesList:  '#replies-list'

  class List.FileInput extends App.Views.ItemView
    template: 'tools_canned_replies/list/_file'

    triggers:
      'click a' : 'import:tools:canned_replies:clicked'

  class List.RepliesList extends App.Views.ItemView
    template: 'tools_canned_replies/list/_list'
