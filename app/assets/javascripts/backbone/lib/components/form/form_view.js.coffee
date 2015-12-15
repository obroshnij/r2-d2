@Artoo.module 'Components.Form', (Form, App, Backbone, Marionette, $, _) ->
  
  class Form.FormWrapper extends App.Views.LayoutView
    template: 'form/layout'
    
    tagName: 'form'
    attributes: ->
      'data-type': @getFormDataType()
      
    regions:
      formContentRegion: '#form-content-region'
        
    ui:
      buttonsContainer: '.button-group'
      
    triggers:
      'submit'                            : 'form:submit'
      'click [data-form-button="cancel"]' : 'form:cancel'
      
    modelEvents:
      'change:_errors' : 'changeErrors'
      'sync:start'     : 'syncStart'
      'sync:stop'      : 'syncStop'
      
    initialize: ->
      @setInstancePropertiesFor 'config', 'buttons'
        
    serializeData: ->
      footer:  @config.footer
      buttons: @buttons?.toJSON() ? false
      
    onShow: ->
      _.defer =>
        @focusFirstInput()  if @config.focusFirstInput
        @buttonsPlacement() if @buttons
        
    buttonsPlacement: ->
      @ui.buttonsContainer.addClass "float-#{@buttons.placement}"
        
    focusFirstInput: ->
      @$(':input:visible:enabled:first').focus()
      
    getFormDataType: ->
      if @model.isNew() then 'new' else 'edit'
      
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
      el.after(sm).closest('.row').addClass('error')
      
    syncStart: (model) ->
      @addOpacityWrapper() if @config.syncing
      
    syncStop: (model) ->
      @addOpacityWrapper(false) if @config.syncing