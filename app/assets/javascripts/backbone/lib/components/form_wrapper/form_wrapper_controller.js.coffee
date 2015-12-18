@Artoo.module 'Components.FormWrapper', (FormWrapper, App, Backbone, Marionette, $, _) ->
    
  class FormWrapper.Controller extends App.Controllers.Application
    
    initialize: (options = {}) ->
      @contentView = options.view
      
      @formLayout = @getFormLayout options.config
      
      @listenTo @formLayout, 'show',        @formContentRegion
      @listenTo @formLayout, 'form:submit', @formSubmit
      @listenTo @formLayout, 'form:cancel', @formCancel
    
    formCancel: ->
      @contentView.triggerMethod 'form:cancel'
    
    formSubmit: ->
      data = Backbone.Syphon.serialize @formLayout
      if @contentView.triggerMethod('form:submit', data) isnt false
        model = @contentView.model
        collection = @contentView.collection
        @processFormSubmit data, model, collection
    
    processFormSubmit: (data, model, collection) ->
      model.save data,
        collection: collection
        
    formContentRegion: ->
      @region = @formLayout.formContentRegion
      @show @contentView
      
    getFormLayout: (options = {}) ->
      config = @getDefaultConfig _.result(@contentView, 'form')
      _.extend config, options
      
      buttons = @getButtons config.buttons
      
      new FormWrapper.Layout
        config:  config
        model:   @contentView.model
        buttons: buttons
        
    getDefaultConfig: (config = {}) ->
      _.defaults config,
        footer:          true
        focusFirstInput: true
        errors:          true
        syncing:         true
        
    getButtons: (buttons = {}) ->
      App.request('form:button:entities', buttons, @contentView.model) unless buttons is false
      
  App.reqres.setHandler 'wrap:form', (contentView, options = {}) ->
    throw new Error "No model found inside of form's contentView" unless contentView.model
    formController = new FormWrapper.Controller
      view:   contentView
      config: options
    formController.formLayout