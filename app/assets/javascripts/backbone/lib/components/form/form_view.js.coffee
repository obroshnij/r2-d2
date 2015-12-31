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
      @$('.is-invalid-input').removeClass('is-invalid-input')
      @$('.is-invalid-label').removeClass('is-invalid-label')
      @$('span.form-error').html('').removeClass('is-visible')
        
    addErrors: (errors = {}) ->
      for name, array of errors
        @addError name, array[0]
        
    addError: (name, error) ->
      $row = @$("[name='#{name}']").addClass('is-invalid-input').closest('.form-field')
      $row.find('span.form-error').html(error).addClass('is-visible')
      $row.find('label').addClass('is-invalid-label')
      
    syncStart: (model) ->
      @addOpacityWrapper() if @config.syncing
      
    syncStop: (model) ->
      @addOpacityWrapper(false) if @config.syncing
      
    onDestroy: ->
      @addOpacityWrapper(false) if @config.syncing