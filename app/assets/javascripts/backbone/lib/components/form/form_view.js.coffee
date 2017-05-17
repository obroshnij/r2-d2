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
      buttons:          '.button-group button'
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
        @config.onShow.call(@) if @config.onShow
        @focusFirstInput()     if @config.focusFirstInput

    events:
      "click button[type='custom']": 'handleCustomButtonClick'

    handleCustomButtonClick: (event) ->
      event.preventDefault()
      event.stopPropagation()
      @trigger "form:#{event.target.textContent.toLowerCase()}"

    buttonsPlacement: ->
      @ui.buttonsContainer.addClass "float-#{@buttons.placement}"

    focusFirstInput: ->
      @$(':input:visible:enabled:first').focus()

    getFormDataType: ->
      if @model.isNew() then 'new' else 'edit'

    getCalloutClass: ->
      return 'secondary' if @config.search
      if @model.isNew() then 'primary' else 'secondary'

    changeErrors: (model, errors, options) ->
      if @config.errors
        if _.isEmpty(errors) then @removeErrors() else @addErrors errors

    removeErrors: ->
      @$('.is-invalid-input').removeClass('is-invalid-input')
      @$('.is-invalid-label').removeClass('is-invalid-label')
      @$('span.form-error').html('').removeClass('is-visible')

    addErrors: (errors = {}) ->
      @removeErrors()
      for name, array of errors
        @addError name, array[0]

    addError: (name, error) ->
      $row = @$("[name='#{name}'], [name='#{name}[]'], [aria-labelledby='select2-#{name}-container']").addClass('is-invalid-input').closest('.form-field')
      $row.find('span.form-error').html(error).addClass('is-visible')
      $row.find('label:not(.errorless)').addClass('is-invalid-label')
      # select2 multiple
      sel2container = $("select[name='#{name}[]'][multiple][aria-hidden='true']").next()
      if sel2container.hasClass('select2-container') and sel2container.find('.select2-selection--multiple')[0]
        sel2container.find('.select2-selection--multiple').addClass('is-invalid-input')

    syncStart: (model) ->
      return unless @config.syncing
      @addOpacityWrapper() if @config.syncingType is 'opacity'
      @disableButtons()    if @config.syncingType is 'buttons'

    syncStop: (model) ->
      return unless @config.syncing
      @addOpacityWrapper(false) if @config.syncingType is 'opacity'
      @disableButtons(false)    if @config.syncingType is 'buttons'

    onDestroy: ->
      @addOpacityWrapper(false) if @config.syncing

    disableButtons: (init = true) ->
      @ui.buttons.prop('disabled', init)
