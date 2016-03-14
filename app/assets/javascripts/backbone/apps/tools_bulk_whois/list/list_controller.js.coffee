@Artoo.module 'ToolsBulkWhoisApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      newLookup = App.request 'new:bulk:whois:lookup:entity'
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @newLookupRegion newLookup
        
      @show @layout
      
    newLookupRegion: (newLookup) ->
      newLookupView = @getNewLookupView()
      
      formView = App.request 'form:component', newLookupView,
        model: newLookup
      
      @show formView, @layout.newLookupRegion
      
    getNewLookupView: ->
      schema = new List.NewLookupSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
    
    getLayoutView: ->
      new List.Layout