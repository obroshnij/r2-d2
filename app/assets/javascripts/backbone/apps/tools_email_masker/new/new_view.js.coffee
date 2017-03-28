@Artoo.module 'ToolsEmailMaskerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'tools_email_masker/new/layout'

    regions:
      formRegion:   '#form-region'
      resultRegion: '#result-region'


  class New.FormSchema extends Marionette.Object

    form:
      buttons:
        primary: 'Submit'
        cancel:  false
      syncingType: 'buttons'

    schema:
      [
        {
          legend: 'Mask email'
          fields: [
            name:     'query'
            label:    'Email Addresses'
            tagName:  'textarea'
          ]
        }
      ]


  class New.Result extends App.Views.ItemView
    template: 'tools_email_masker/new/result'

    modelEvents:
      'sync:stop' : 'render'

    onAttach: ->
      @destroy() unless @model.get('mask')
