@Artoo.module "Components.Pagination", (Pagination, App, Backbone, Marionette, $, _) ->
  
  class Pagination.PaginationController extends App.Controllers.Application
    
    initialize: (options) ->
      paginationView = new Pagination.PaginationView
        collection: options.collection
      
      @setMainView paginationView
  
  
  App.reqres.setHandler "pagination:component", (collection, options = {}) ->
    throw new Error "Pagination Component requires a collection to be passed in" if not collection

    options.collection = collection
    new Pagination.PaginationController options