@Artoo.module 'LegalBulkCurlApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      newRequest = App.request 'list:bulk:curl:entity'
      requests   = App.request 'list:bulk:curl:entities'

      @timer = setInterval (-> requests.fetch()), 5000

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @newRequestRegion newRequest
        @requestsRegion requests

      @show @layout
      
    onDestroy: ->
      clearTimeout @timer
      
    newRequestRegion: (newRequest) ->
      newRequestView = @getNewRequestView()
      
      formView = App.request 'form:component', newRequestView,
        model:          newRequest
        onBeforeSubmit: -> newRequest.unset('id')
      
      @show formView, region: @layout.newRequestRegion

    requestsRegion: (requests) ->
      requestsView = @getRequestsView requests

      @listenTo requestsView, 'childview:retry:clicked', (child, args) ->
        args.model.retryFailed()

      @listenTo requestsView, 'childview:show:clicked', (child, args) ->
        App.vent.trigger 'show:bulk:curl:request:clicked', args.model

      @show requestsView, region: @layout.requestsRegion, loading: true

    getRequestsView: (requests) ->
      new List.RequestsView
        collection: requests

    getNewRequestView: ->
      schema = new List.NewRequestSchema
      App.request 'form:fields:component',
        schema: schema
        model:  false
    
    getLayoutView: ->
      new List.Layout