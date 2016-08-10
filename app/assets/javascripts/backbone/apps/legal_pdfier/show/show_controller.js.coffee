@Artoo.module 'LegalPdfierApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Application

    initialize: (options) ->
      report = App.request 'pdf:report:entity', options.id
      window.report = report

      @listenTo App.vent, 'helper:extension:export', ->
        report.fetch()

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @panelRegion report
        @pagesRegion report

      @show @layout

    panelRegion: (report) ->
      panelView = @getPanelView report

      @listenTo panelView, 'toggle:edit:report:clicked', (args) ->

        if !args.model.get('edited_by') and confirm("This will enable edit mode for this report and disable for all other reports you are currently editing (if any). Other users will be unable to edit this report while edit mode is enabled by you")
          args.model.toggleEditMode()

        if args.model.get('edited_by')
          args.model.toggleEditMode()

      @listenTo panelView, 'merge:clicked', (args) ->
        args.model.merge()

      @show panelView, region: @layout.panelRegion

    pagesRegion: (report) ->
      pagesView = @getPagesView report

      @listenTo pagesView, 'childview:checkbox:clicked', (childView, args) ->
        args.model.set 'checked', !args.model.get('checked')

      @listenTo pagesView, 'check:all', (args) ->
        args.model.pages.each (page) -> page.set('checked', true)

      @listenTo pagesView, 'uncheck:all', (args) ->
        args.model.pages.each (page) -> page.set('checked', false)

      @show pagesView,
        region:   @layout.pagesRegion
        loading:  true
        entities: report

    getPagesView: (report) ->
      new Show.Pages
        model: report

    getPanelView: (report) ->
      new Show.Panel
        model: report

    getLayoutView: ->
      new Show.Layout
