@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.PdfReportPage extends App.Entities.Model

    defaults:
      checked: false

  class Entities.PdfReportPagesCollection extends App.Entities.Collection
    model: Entities.PdfReportPage


  class Entities.PdfReport extends App.Entities.Model
    urlRoot: -> Routes.legal_pdf_reports_path()

    resourceName: 'Legal::PdfReport'

    initialize: ->
      @pages   = new Entities.PdfReportPagesCollection
      @checked = []

      @listenTo @, 'sync', =>
        @pages.reset @get('pages')
        @unset 'pages'

        @checked = @checked.filter (id) => @pages.find(id: id)

        _.each @checked, (id) => @pages.find(id: id).set('checked', true)

      @listenTo @pages, 'change:checked', =>
        checked   = @pages.select(checked: true)

        @checked  = _.map checked, (page) -> page.id
        @canMerge = checked.length > 1 and _.chain(checked).map((page) -> page.get('name')).uniq().value().length is 1

        @trigger 'change'

    mutators:
      title: ->
        if @get('username') && @get('created_at_formatted')
          "#{@get('username')} - #{@get('created_at_formatted')?.split(',')[0]}"
        else
          ""

    toggleEditMode: (attributes = {}, options = {}) ->
      options.url = Routes.toggle_edit_legal_pdf_report_path(@id)
      @save attributes, options

    merge: (attributes = {}, options = {}) ->
      options.url = Routes.merge_legal_pdf_report_path(@id)
      @set 'to_merge', @checked
      @save attributes, options


  class Entities.PdfReportsCollection extends App.Entities.Collection
    model: Entities.PdfReport

    url: -> Routes.legal_pdf_reports_path()


  API =

    getPdfReportsCollection: ->
      reports = new Entities.PdfReportsCollection
      reports.fetch()
      reports

    getNewPdfReport: ->
      new Entities.PdfReport

    getPdfReport: (id) ->
      report = new Entities.PdfReport id: id
      report.fetch()
      report


  App.reqres.setHandler 'pdf:report:entities', ->
    API.getPdfReportsCollection()

  App.reqres.setHandler 'new:pdf:report:entity', ->
    API.getNewPdfReport()

  App.reqres.setHandler 'pdf:report:entity', (id) ->
    API.getPdfReport id
