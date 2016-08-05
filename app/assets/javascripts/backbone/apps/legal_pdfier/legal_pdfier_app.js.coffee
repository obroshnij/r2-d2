@Artoo.module 'LegalPdfierApp', (LegalPdfierApp, App, Backbone, Marionette, $, _) ->

  class LegalPdfierApp.Router extends App.Routers.Base

    appRoutes:
      'legal/pdfier' : 'list'

  API =

    list: (region) ->
      return App.execute 'legal:list', 'PDFier', { action: 'list' } if not region

      new LegalPdfierApp.List.Controller
        region: region


  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'PDFier'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/legal/pdfier'
      API.list region

  App.vent.on 'helper:extension:export', -> console.log 'Export!'


  LegalPdfierApp.on 'start', ->
    new LegalPdfierApp.Router
      controller: API
      resource:   'Legal::PdfReport'
