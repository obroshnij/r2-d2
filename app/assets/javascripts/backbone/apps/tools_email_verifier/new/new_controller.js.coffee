@Artoo.module 'ToolsEmailVerifierApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      verifier = App.request 'email:verifier:entity'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @formRegion verifier
        
      @show @layout
      
    formRegion: (verifier) ->
      newView = @getNewView()
      
      formView = App.request 'form:component', newView,
        model:          verifier
        onBeforeSubmit: -> verifier.unset('records', silent: true)
        
      @listenTo formView, 'form:submit', =>
        @resultRegion verifier
        
      @show formView, region: @layout.formRegion
      
    resultRegion: (verifier) ->
      resultView = @getResultView verifier.records
      
      @listenTo resultView, 'childview:show:session:clicked', (childView, args) ->
        App.vent.trigger 'show:smtp:session', args.model
      
      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'
    
      @show resultView,
        loading:
          loadingType: loadingType
          entities:    verifier
        region:  @layout.resultRegion
    
    getResultView: (records) ->
      new New.Results
        collection: records
      
    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
      
    getLayoutView: ->
      new New.Layout