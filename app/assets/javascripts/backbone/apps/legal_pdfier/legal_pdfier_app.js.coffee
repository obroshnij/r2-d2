@Artoo.module 'LegalPdfierApp', (LegalPdfierApp, App, Backbone, Marionette, $, _) ->

  class LegalPdfierApp.Router extends App.Routers.Base

    appRoutes:
      'legal/pdfier'     : 'list'
      'legal/pdfier/:id' : 'show'

  API =

    list: (region) ->
      return App.execute 'legal:list', 'PDFier', { action: 'list' } if not region

      new LegalPdfierApp.List.Controller
        region: region

    newReport: (reports) ->
      new LegalPdfierApp.New.Controller
        region:  App.modalRegion
        reports: reports

    show: (id, region) ->
      return App.execute 'legal:list', 'PDFier', { action: 'show', id: id } if not region

      new LegalPdfierApp.Show.Controller
        region: region
        id:     id


  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'PDFier'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate '/legal/pdfier'
      API.list region

    if action is 'show'
      App.navigate "legal/pdfier/#{options.id}"
      API.show options.id, region

  App.vent.on 'new:pdf:report:clicked', (reports) ->
    API.newReport reports

  App.vent.on 'show:report:clicked', (report) ->
    API.show report.id


  LegalPdfierApp.on 'start', ->
    new LegalPdfierApp.Router
      controller: API
      resource:   'Legal::PdfReport'
