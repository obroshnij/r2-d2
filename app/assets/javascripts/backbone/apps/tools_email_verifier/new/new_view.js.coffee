@Artoo.module 'ToolsEmailVerifierApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'tools_email_verifier/new/layout'

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
          legend: 'Verify email'
          fields: [
            name:     'query'
            label:    'Email Addresses'
            tagName:  'textarea'
          ]
        }
      ]


  class New.Result extends App.Views.ItemView
    template: 'tools_email_verifier/new/result'
    tagName:  'tr'

    triggers:
      'click a.show-session' : 'show:session:clicked'


  class New.Results extends App.Views.CompositeView
    template: 'tools_email_verifier/new/results'

    childView:          New.Result
    childViewContainer: 'tbody'

    onDomRefresh: ->
      @$('table').tablesorter
        headers:
          3: sorter: false

    onAttach: ->
      @destroy() unless @collection.models.length
