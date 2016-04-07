@Artoo.module 'LegalRblsCheckerApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      checker = App.request 'legal:rbl:checker:entity'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @panelRegion()
        @formRegion checker
        
      @show @layout
      
    formRegion: (checker) ->
      newView = @getNewView()
      
      formView = App.request 'form:component', newView,
        model:          checker
        onBeforeSubmit: -> checker.unset('query', silent: true)
        
      @listenTo formView, 'form:submit', =>
        @resultRegion checker
            
      @show formView, region: @layout.formRegion
      
    resultRegion: (checker) ->
      resultView = @getResultView checker
      
      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'
      
      @show resultView,
        loading:
          loadingType: loadingType
          entities:    checker
        region:  @layout.resultRegion
      
    panelRegion: ->
      panelView = @getPanelView()
      
      @show panelView, region: @layout.panelRegion
      
    getPanelView: ->
      new New.Panel
      
    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
        
    getResultView: (checker) ->
      new New.Results
        collection: checker.result
      
    getLayoutView: ->
      new New.Layout