@Artoo.module 'ToolsDataExtractorApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Details extends App.Views.ItemView
    template: 'tools_data_extractor/show/details'

    modal:
      title: 'More Info'
      size:  'tiny'
