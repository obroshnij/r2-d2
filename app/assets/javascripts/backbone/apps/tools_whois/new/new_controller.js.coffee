@Artoo.module 'ToolsWhoisApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      whois_record = App.request 'whois:lookup:entity'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @formRegion   whois_record
        @resultRegion whois_record
      
      @show @layout
      
    formRegion: (whois_record) ->
      newView = @getNewView()
      
      formView = App.request 'form:component', newView,
        model:          whois_record
        onBeforeSubmit: -> whois_record.unset('record', silent: true)
            
      @show formView, region: @layout.formRegion
      
    resultRegion: (whois_record) ->
      resultView = @getResultView whois_record
      @show resultView, region: @layout.resultRegion
      
    getResultView: (whois_record) ->
      new New.Result
        model: whois_record
      
    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
      
    getLayoutView: ->
      new New.Layout