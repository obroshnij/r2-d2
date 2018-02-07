@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Model extends Backbone.Model

    _entityType: 'model'

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
      @set _errors: xhr.responseJSON.errors unless _.contains([500, 404, 403], xhr.status)
      App.execute 'notify:error', xhr.responseJSON.error if xhr.status is 403

    destroy: (options = {}) ->
      _.defaults options,
        wait:  true
        error:  _.bind(@destroyError, @)

      @set _destroy: true
      super options

    destroyError: (model, xhr, options) =>
      App.execute 'notify:error', xhr.responseJSON.error if xhr.status is 403

    isDestroyed: ->
      @get '_destroy'

    fetch: (options = {}) ->
      _.defaults options,
        error: _.bind(@fetchError, @)
      super options

    fetchError: (model, xhr, options) =>
      App.execute 'notify:error', xhr.responseJSON.error if xhr.status is 403


  App.reqres.setHandler 'new:model', (attrs = {}) ->
    new Entities.Model attrs
