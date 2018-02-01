@Artoo.module 'ToolsCannedRepliesApp.Import', (Import, App, Backbone, Marionette, $, _) ->

  class Import.Schema extends Marionette.Object

    modal:
      size:  'tiny'
      title: 'New Import'

    schema: ->
      [
        legend:   'New Import'
        hasHints: false

        fields: [
          name:    'name'
          label:   'Name'
        ,
          name:    'comment'
          label:   'Comments'
          tagName: 'textarea'
        ]
      ]
