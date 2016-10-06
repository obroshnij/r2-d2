@Artoo.module 'LegalDblSurblCheckerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'legal_dbl_surbl_checker/new/layout'

    regions:
      formRegion:   '#form-region'
      resultRegion: '#result-region'