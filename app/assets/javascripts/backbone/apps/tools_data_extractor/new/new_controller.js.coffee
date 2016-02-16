@Artoo.module 'ToolsDataExtractorApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      dataSearch = App.request 'data:search:entity'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @formRegion dataSearch
      
      @show @layout
      
    formRegion: (dataSearch) ->
      newView = @getNewView()
      
      formView = App.request 'form:component', newView,
        model:          dataSearch
        onBeforeSubmit: -> dataSearch.unset('items', silent: true)
        
      @listenTo formView, 'form:submit', =>
        @resultRegion dataSearch
      
      @show formView, region: @layout.formRegion
      
    resultRegion: (dataSearch) ->
      resultView = @getResultView dataSearch
      
      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'
      
      @show resultView,
        loading:
          loadingType: loadingType
        region:  @layout.resultRegion
        
    getResultView: (dataSearch) ->
      new New.Result
        model: dataSearch
      
    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
      
    getLayoutView: ->
      new New.Layout