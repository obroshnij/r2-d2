@Artoo.module 'LegalLinkDisablerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      link = App.request 'link:disabler:entity'

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion link

      @show @layout

    formRegion: (link) ->
      newView = @getNewView()

      formView = App.request 'form:component', newView,
        model:          link
        onBeforeSubmit: -> link.unset('items', silent: true)

      @listenTo formView, 'form:submit', =>
        @resultRegion link

      @show formView, region: @layout.formRegion

    resultRegion: (link) ->
      resultView = @getResultView link

      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'

      @show resultView,
        loading:
          loadingType: loadingType
        region:  @layout.resultRegion

    getResultView: (link) ->
      console.log(link)
      new New.Result
        model: link

    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false

    getLayoutView: ->
      new New.Layout
