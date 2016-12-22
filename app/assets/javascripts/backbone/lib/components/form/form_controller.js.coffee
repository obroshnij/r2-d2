@Artoo.module 'Components.Form', (Form, App, Backbone, Marionette, $, _) ->

  class Form.FormController extends App.Controllers.Application

    defaults: ->
      footer:               true
      focusFirstInput:      true
      errors:               true
      syncing:              true
      syncingType:          'opacity'
      search:               false
      proxy:                false
      deserialize:          false
      deserializeOnSuccess: false
      saveMethod:           'save'
      onBeforeSubmit:       ->
      onCancel:             ->
      onSuccess:            ->

    initialize: (options = {}) ->
      { @contentView } = options

      @model = @getModel options

      config = @getConfig options

      @formLayout = @getFormLayout config
      @setMainView @formLayout

      @parseProxys config.proxy if config.proxy
      @createListeners config

    createListeners: (config) ->
      @listenTo @formLayout, 'show',        => @formContentRegion(config)

      @listenTo @formLayout, 'form:submit', => @formSubmit(config)
      @listenTo @formLayout, 'form:cancel', => @formCancel(config)

    formSubmit: (config) ->
      config.onBeforeSubmit()

      data = Backbone.Syphon.serialize @formLayout
      @processModelSave(data, config) unless @_saveModel is false

      @trigger 'form:submit', data

    processModelSave: (data, config) ->
      @model[config.saveMethod] data,
        callback: config.onSuccess

    formCancel: (config) ->
      config.onCancel()
      @trigger 'form:cancel'

    parseProxys: (proxys) ->
      for proxy in _([proxys]).flatten()
        @formLayout[proxy] = _.result @contentView, proxy

    getConfig: (options) ->
      form = _.result @contentView, "form"

      config = @mergeDefaultsInto(form)

      _.extend config, _(options).omit("contentView", "model", "collection")

      if config.deserializeOnSuccess
        onSuccess = config.onSuccess
        config.onSuccess = () =>
          onSuccess()
          Backbone.Syphon.deserialize @formLayout, @model.toJSON()

      config

    getModel: (options) ->
      model = options.model or @contentView.model
      if options.model is false
        model = App.request 'new:model'
        @_saveModel = false
      model

    formContentRegion: (config) ->
      @show @contentView, region: @formLayout.formContentRegion
      Backbone.Syphon.deserialize @formLayout, @model.toJSON() if config.deserialize

    getFormLayout: (config) ->
      new Form.FormLayout
        config: config
        model: @model
        buttons: @getButtons config.buttons

    getButtons: (buttons = {}) ->
      App.request("form:button:entities", buttons, @model) unless buttons is false

  App.reqres.setHandler "form:component", (contentView, options = {}) ->
    throw new Error "Form Component requires a contentView to be passed in" if not contentView

    options.contentView = contentView
    new Form.FormController options
