@Artoo.module 'LegalPdfierApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'legal_pdfier/list/layout'

    regions:
      panelRegion: '#panel-region'


  class List.Panel extends App.Views.ItemView
    template: 'legal_pdfier/list/panel'
