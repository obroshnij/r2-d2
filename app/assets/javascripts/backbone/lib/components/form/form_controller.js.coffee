@Artoo.module 'Components.Form', (Form, App, Backbone, Marionette, $, _) ->
    
  class Form.FormController extends App.Controllers.Application
    
    defaults: ->
      footer: true
      focusFirstInput: true
    
    initialize: (options = {}) ->
      { @contentView } = options

      @model = @getModel options
      
      config = @getConfig options

      @formLayout = @getFormLayout config
      @setMainView @formLayout

      @createListeners config
      
    createListeners: (config) ->
      @listenTo @formLayout, "show", @formContentRegion
      
    getConfig: (options) ->
      form = _.result @contentView, "form"

      config = @mergeDefaultsInto(form)

      _.extend config, _(options).omit("contentView", "model", "collection")

    getModel: (options) ->
      options.model or @contentView.model
      
    formContentRegion: ->
      @show @contentView, region: @formLayout.formContentRegion
      Backbone.Syphon.deserialize @formLayout, @model.toJSON()
      @formLayout.$el.find("input, select, textarea").change()
      
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