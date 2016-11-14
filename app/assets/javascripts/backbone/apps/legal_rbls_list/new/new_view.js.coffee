@Artoo.module 'LegalRblsListApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Schema extends Marionette.Object

    modal:
      size:  'tiny'
      title: 'New RBL'

    schema: ->
      [
        legend:   'New RBL'
        hasHints: false

        fields: [
          name:    'name'
          label:   'Name'
        ,
          name:    'rbl_status_id'
          label:   'Status'
          tagName: 'select'
          options: @getStatuses()
        ,
          name:    'url'
          label:   'URL'
        ,
          name:    'comment'
          label:   'Comment'
          tagName: 'textarea'
        ]
      ]

    getStatuses: ->
      App.entities.legal.rbl_status
