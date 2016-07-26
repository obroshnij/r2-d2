@Artoo.module 'ToolsInternalDomainsApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Schema extends Marionette.Object

    modal:
      size:  'tiny'
      title: 'New Internal Domain'

    schema: ->
      [
        legend:   'New Internal Domain'
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
