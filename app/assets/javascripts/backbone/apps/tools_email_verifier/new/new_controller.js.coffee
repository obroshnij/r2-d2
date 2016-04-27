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
      resultView = @getResultView verifier
      
      @listenTo resultView, 'show:smtp:session', (email) ->
        session = _.find(verifier.get('records'), (obj) -> obj['email'] is email).session
        App.vent.trigger 'show:smtp:session', email, session
      
      loadingType = if @layout.resultRegion.currentView then 'opacity' else 'spinner'
    
      @show resultView,
        loading:
          loadingType: loadingType
        region:  @layout.resultRegion
    
    getResultView: (verifier) ->
      new New.Result
        model: verifier
      
    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
      
    getLayoutView: ->
      new New.Layout