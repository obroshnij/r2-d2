@Artoo.module 'ToolsBulkDigApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      bulkDig = App.request 'bulk:dig:entity'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @formRegion bulkDig
      
      @show @layout
      
    formRegion: (bulkDig) ->
      newView = @getNewView()
      
      formView = App.request 'form:component', newView,
        model:          bulkDig
        onBeforeSubmit: -> bulkDig.unset('records', silent: true)
        
      @listenTo formView, 'form:submit', =>
        @resultRegion bulkDig
        
      @show formView, region: @layout.formRegion
      
    resultRegion: (bulkDig) ->
      resultView = @getResultView bulkDig
      
      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'
      
      @show resultView,
        loading:
          loadingType: loadingType
        region:  @layout.resultRegion
      
    getResultView: (bulkDig) ->
      new New.Result
        model: bulkDig
      
    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
      
    getLayoutView: ->
      new New.Layout