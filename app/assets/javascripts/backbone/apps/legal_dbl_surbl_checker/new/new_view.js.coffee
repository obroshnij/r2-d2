@Artoo.module 'LegalDblSurblCheckerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'legal_dbl_surbl_checker/new/layout'

    regions:
      formRegion:   '#form-region'
      resultRegion: '#result-region'

  class New.Schema extends Marionette.Object

    form:
      buttons:
        primary: 'Submit'
        cancel:  false
      syncingType: 'buttons'

    schema: ->
      [
        legend:   'DBL/SURBL Check'

        fields: [
          name:    'query'
          label:   'Domains'
          tagName: 'textarea'
        ]
      ]


  class New.Result extends App.Views.ItemView
    template: 'legal_dbl_surbl_checker/new/result'
    tagName:  'tr'

    triggers:
      'click a.show-session' : 'show:session:clicked'


  class New.Results extends App.Views.CompositeView
    template: 'legal_dbl_surbl_checker/new/results'

    childView:          New.Result
    childViewContainer: 'tbody'