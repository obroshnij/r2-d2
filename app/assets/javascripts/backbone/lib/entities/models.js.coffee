@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Model extends Backbone.Model
    
    save: (data, options = {}) ->
      isNew = @isNew()
      
      _.defaults options,
        wait:    true
        success: _.bind(@saveSuccess, @, isNew, options.collection, options.callback)
        error:   _.bind(@saveError, @)
        
      @unset '_errors'
      super data, options
      
    saveSuccess: (isNew, collection, callback) =>
      if isNew
        collection?.add @
        collection?.trigger 'model:created', @
        @trigger 'created', @
      else
        collection ?= @collection
        collection?.trigger 'model:updated', @
        @trigger 'updated', @
        
      callback?()
        
    saveError: (model, xhr, options) =>
      @set _errors: xhr.responseJSON.errors unless xhr.status is 500 or xhr.status is 404
      
    destroy: (options = {}) ->
      _.defaults options,
        wait: true
      
      @set _destroy: true
      super options
      
    isDestroyed: ->
      @get '_destroy'
  
  
  App.reqres.setHandler 'new:model', (attrs = {}) ->
    new Entities.Model attrs