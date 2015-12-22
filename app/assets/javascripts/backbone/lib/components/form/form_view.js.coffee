@Artoo.module 'Components.Form', (Form, App, Backbone, Marionette, $, _) ->
  
  class Form.FormLayout extends App.Views.LayoutView
    template: 'form/layout'
    
    tagName: 'form'
    attributes: ->
      'data-type': @getFormDataType()
      
    regions:
      formContentRegion: '#form-content-region'
        
    ui:
      buttonsContainer: '.button-group'
      callout:          '.callout'
      
    triggers:
      'submit'                            : 'form:submit'
      'click [data-form-button="cancel"]' : 'form:cancel'
      
    modelEvents:
      'change:_errors' : 'changeErrors'
      'sync:start'     : 'syncStart'
      'sync:stop'      : 'syncStop'
      
    initialize: ->
      { @config, @buttons } = @options
        
    serializeData: ->
      footer:  @config.footer
      buttons: @buttons?.toJSON() ? false
      
    onBeforeAttach: ->
      @ui.callout.addClass @getCalloutClass()
      @buttonsPlacement() if @buttons
      
    onShow: ->
      _.defer =>
        @focusFirstInput()  if @config.focusFirstInput
        
    buttonsPlacement: ->
      @ui.buttonsContainer.addClass "float-#{@buttons.placement}"
        
    focusFirstInput: ->
      @$(':input:visible:enabled:first').focus()
      
    getFormDataType: ->
      if @model.isNew() then 'new' else 'edit'
      
    getCalloutClass: ->
      if @model.isNew() then 'primary' else 'secondary'
      
    changeErrors: (model, errors, options) ->
      if @config.errors
        if _.isEmpty(errors) then @removeErrors() else @addErrors errors
        
    removeErrors: ->
      @$('div.error').removeClass('error').find('small').remove()
        
    addErrors: (errors = {}) ->
      for name, array of errors
        @addError name, array[0]
        
    addError: (name, error) ->
      el = @$("[name='#{name}']")
      sm = $('<small>').text(error).addClass('error')
      @insertError(el, sm)
      
    insertError: (el, sm) ->
      parent = el.closest(".row").addClass("error")
      error_container = parent.find(".error-container")
      if error_container.length then error_container.html(sm) else el.after(sm)
      
    syncStart: (model) ->
      @addOpacityWrapper() if @config.syncing
      
    syncStop: (model) ->
      @addOpacityWrapper(false) if @config.syncing
      
    onDestroy: ->
      @addOpacityWrapper(false) if @config.syncing