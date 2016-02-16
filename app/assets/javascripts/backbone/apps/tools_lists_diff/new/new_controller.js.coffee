@Artoo.module 'ToolsListsDiffApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      diff = App.request 'lists:diff:entity'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @formRegion diff
      
      @show @layout
      
    formRegion: (diff) ->
      newView = @getNewView()
      
      formView = App.request 'form:component', newView,
        model:          diff
        onBeforeSubmit: ->
          diff.unset('list_one', silent: true)
          diff.unset('list_two', silent: true)
        
      @listenTo formView, 'form:submit', =>
        @resultRegion diff
            
      @show formView, region: @layout.formRegion
      
    resultRegion: (diff) ->
      resultView = @getResultView diff
      
      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'
      
      @show resultView,
        loading:
          loadingType: loadingType
        region:  @layout.resultRegion
      
    getResultView: (diff) ->
      new New.Result
        model: diff
      
    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
      
    getLayoutView: ->
      new New.Layout