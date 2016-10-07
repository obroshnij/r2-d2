@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.BulkCurl extends App.Entities.Model
    urlRoot: -> Routes.legal_bulk_curl_requests_path()
      
    statusColorRequests: { 'Enqueued': 'secondary', 'In Progress': 'primary', 'Processed': 'success' }
    
    mutators:
        
      statusColor: ->
        @statusColorRequests[@get('status')] if @get('status')

  
  class Entities.BulkCurlCollection extends App.Entities.Collection
    model: Entities.BulkCurl

    url: -> Routes.legal_bulk_curl_requests_path()
    
    
  API =
    
    newBulkCurl: (attrs) ->
      new Entities.BulkCurl attrs
      
    newBulkCurlCollection: ->
      requests = new Entities.BulkCurlCollection
      requests.fetch()
      requests
      
    getBulkCurl: (id) ->
      request = new Entities.BulkCurl id: id
      request.fetch()
      request
      
  App.reqres.setHandler 'list:bulk:curl:entity', (attrs = {}) ->
    API.newBulkCurl attrs
    
  App.reqres.setHandler 'list:bulk:curl:entities', ->
    API.newBulkCurlCollection()

  App.reqres.setHandler 'bulk:curl:entity', (id) ->
    API.getBulkCurl id