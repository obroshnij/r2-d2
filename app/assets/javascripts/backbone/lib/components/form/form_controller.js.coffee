@Artoo.module 'Components.Form', (Form, App, Backbone, Marionette, $, _) ->
    
  class Form.FormController extends App.Controllers.Application
    
    defaults: ->
      footer:          true
      focusFirstInput: true
      errors:          true
      syncing:         true
      syncingType:     'opacity'
      search:          false
      onBeforeSubmit:  ->
      onCancel:        ->
    
    initialize: (options = {}) ->
      { @contentView } = options

      @model = @getModel options
      
      config = @getConfig options

      @formLayout = @getFormLayout config
      @setMainView @formLayout

      @createListeners config
      
    createListeners: (config) ->
      @listenTo @formLayout, 'show', @formContentRegion
      
      @listenTo @formLayout, 'form:submit', => @formSubmit(config)
      @listenTo @formLayout, 'form:cancel', => @formCancel(config)
      
    formSubmit: (config) ->
      config.onBeforeSubmit()
      
      data = Backbone.Syphon.serialize @formLayout
      @processModelSave data
      
      @trigger 'form:submit', data
      
    processModelSave: (data) ->
      @model.save(data) unless @_saveModel is false
      
    formCancel: (config) ->
      config.onCancel()
      @trigger 'form:cancel'
      
    getConfig: (options) ->
      form = _.result @contentView, "form"

      config = @mergeDefaultsInto(form)

      _.extend config, _(options).omit("contentView", "model", "collection")
    
    getModel: (options) ->
      model = options.model or @contentView.model
      if options.model is false
        model = App.request 'new:model'
        @_saveModel = false
      model
      
    formContentRegion: ->
      @show @contentView, region: @formLayout.formContentRegion
      Backbone.Syphon.deserialize @formLayout, @model.toJSON()
      
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