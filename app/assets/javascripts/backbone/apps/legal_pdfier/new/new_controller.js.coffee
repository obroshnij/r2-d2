@Artoo.module 'LegalPdfierApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      report  = App.request 'new:pdf:report:entity'
      reports = options.reports

      newView = @getNewView report

      form = App.request 'form:component', newView,
        proxy:     'modal'
        model:     report
        onCancel:  => @region.empty()
        onSuccess: => @region.empty() and reports.search()

      @show form

    getNewView: (report) ->
      schema = new New.Schema

      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema
        model:  report
