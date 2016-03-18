@Artoo.module 'ToolsBulkWhoisApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      newLookup = App.request 'new:bulk:whois:lookup:entity'
      lookups   = App.request 'bulk:whois:lookup:entities'
      
      @timer = setInterval (-> lookups.fetch()), 5000
      
      @layout = @getLayoutView()
      
      @listenTo @layout, 'show', =>
        @newLookupRegion lookups, newLookup
        @lookupsRegion lookups
        
      @show @layout
      
    onDestroy: ->
      clearTimeout @timer
      
    newLookupRegion: (lookups, newLookup) ->
      newLookupView = @getNewLookupView()
      
      formView = App.request 'form:component', newLookupView,
        model:          newLookup
        onBeforeSubmit: -> newLookup.unset('id')
        
      @listenTo formView, 'form:submit', (data) ->
        lookups.search()
      
      @show formView, region: @layout.newLookupRegion
      
    lookupsRegion: (lookups) ->
      lookupsView = @getLookupsView lookups
      
      @listenTo lookupsView, 'childview:retry:clicked', (child, args) ->
        args.model.retryFailed()
      
      @listenTo lookupsView, 'childview:show:clicked', (child, args) ->
        App.vent.trigger 'show:bulk:whois:lookup:clicked', args.model
      
      @listenTo lookupsView, 'childview:delete:clicked', (child, args) ->
        if confirm "Are you sure you want to delete this record?" then args.model.destroy() else false
      
      @show lookupsView, region: @layout.lookupsRegion, loading: true
      
    getLookupsView: (lookups) ->
      new List.LookupsView
        collection: lookups
      
    getNewLookupView: ->
      schema = new List.NewLookupSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
    
    getLayoutView: ->
      new List.Layout