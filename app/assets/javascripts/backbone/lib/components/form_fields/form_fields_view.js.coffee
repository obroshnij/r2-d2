@Artoo.module 'Components.FormFields', (FormFields, App, Backbone, Marionette, $, _) ->

  # Form input views

  class FormFields.BaseInputView extends App.Views.ItemView
    getTemplate: ->
      if @model.isCompact() then 'form_fields/input_compact' else 'form_fields/input'

    attributes: ->
      class: if @model.isCompact() then 'form-field column' else 'form-field row'
      id:    @model.get('elementId')
      style: if @model.isShown() then 'display:block;' else 'display:none;'

    ui: ->
      input: "#{@getTagName()}"

    getTagName: ->
      @model.get 'tagName'

    getNameAttr: ->
      @model.get 'name'

    events:
      'change @ui.input' : 'updateModelValue'

    updateModelValue: ->
      @model.set 'value', @currentValue()

      @trigger 'value:changed', @getNameAttr(), @currentValue()

    currentValue: ->
      data = Backbone.Syphon.serialize(@el)
      path = _.compact @getNameAttr().split(/[\[\]]/)
      _.reduce path, ((obj, key) -> obj[key]), data

    @include 'DynamicFormView'


  class FormFields.TextFieldView extends FormFields.BaseInputView


  class FormFields.NumberFieldView extends FormFields.BaseInputView


  class FormFields.TextAreaView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/textarea'


  class FormFields.SelectView extends FormFields.BaseInputView
    getTemplate: ->
      if @model.isCompact() then 'form_fields/select_compact' else 'form_fields/select'

    ui: ->
      ui = { input: "#{@getTagName()}" }
      ui[option.id] = "option[value='#{option.id}']" for option in @model.attributes.options
      ui

    modelEvents:
      'change:isShown'  : 'toggle'
      'enable:options'  : 'enableOptions'
      'disable:options' : 'disableOptions'

    enableOptions: (ids) ->
      @ui[id].attr('disabled', false) for id in _.flatten([ids])

    disableOptions: (ids) ->
      @ui[id].attr('disabled', true) for id in _.flatten([ids])
      @uncheckDisabled()

    uncheckDisabled: ->
      _.defer =>
        if @$("option:selected").prop('disabled')
          @ui.input.val('')
          @updateModelValue()


  class FormFields.Select2View extends FormFields.SelectView

    onShow: ->
      @$('select').select2()

      @$('select').on 'select2:open', =>


    onDestroy: ->
      @$('select').off()
      @$('select').select2 'destroy'


  class FormFields.Select2AjaxView extends FormFields.SelectView

    onShow: ->
      @$('select').select2
        ajax:
          url:      @model.get('url')
          dataType: 'json'
          data:     @model.get('data')
          processResults: (data) ->
            results: _.map data, (item) ->
              id: item.id, text: item.name

    onDestroy: ->
      @$('select').off()
      @$('select').select2 'destroy'


  class FormFields.Select2MultiView extends FormFields.Select2View
    getTemplate: ->
      if @model.isCompact() then 'form_fields/select_multi_compact' else 'form_fields/select_multi'


  class FormFields.CollectionCheckBoxesView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/collection_check_boxes'

    ui: ->
      ui = { input: "#{@getTagName()}" }
      ui[option.id] = "[id='#{@model.get('name')}_#{option.id}']" for option in @model.attributes.options
      ui

    modelEvents:
      'change:isShown'  : 'toggle'
      'enable:options'  : 'enableOptions'
      'disable:options' : 'disableOptions'

    enableOptions: (ids) ->
      @ui[id].attr('disabled', false) for id in _.flatten([ids])

    disableOptions: (ids) ->
      @ui[id].attr('disabled', true) for id in _.flatten([ids])
      @uncheckDisabled()

    uncheckDisabled: ->
      _.defer =>
        unchecked = false
        @$("input:checked").each (index, option) ->
          if $(option).prop('disabled')
            $(option).prop('checked', false)
            unchecked = true

        @updateModelValue() if unchecked


  class FormFields.RadioButtonsView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/radio_buttons'

    ui: ->
      ui = { input: "#{@getTagName()}" }
      ui[option.id] = "[id='#{@model.get('name')}_#{option.id}']" for option in @model.attributes.options
      ui

    modelEvents:
      'change:isShown'  : 'toggle'
      'enable:options'  : 'enableOptions'
      'disable:options' : 'disableOptions'

    enableOptions: (ids) ->
      @ui[id].attr('disabled', false) for id in _.flatten([ids])

    disableOptions: (ids) ->
      @ui[id].attr('disabled', true) for id in _.flatten([ids])
      @uncheckDisabled()

    uncheckDisabled: ->
      _.defer =>
        if @$("input:checked").prop('disabled')
          @$("input:enabled:first").prop('checked', true)
          @updateModelValue()


  class FormFields.CollectionRadioButtonsView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/collection_radio_buttons'

    ui: ->
      ui = { input: "#{@getTagName()}" }
      ui[option.id] = "[id='#{@model.get('name')}_#{option.id}']" for option in @model.attributes.options
      ui

    modelEvents:
      'change:isShown'  : 'toggle'
      'enable:options'  : 'enableOptions'
      'disable:options' : 'disableOptions'

    enableOptions: (ids) ->
      @ui[id].attr('disabled', false) for id in _.flatten([ids])

    disableOptions: (ids) ->
      @ui[id].attr('disabled', true) for id in _.flatten([ids])
      @uncheckDisabled()

    uncheckDisabled: ->
      _.defer =>
        if @$("input:checked").prop('disabled')
          @$("input:enabled:first").prop('checked', true)
          @updateModelValue()


  class FormFields.HiddenFieldView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/hidden'


  class FormFields.DateRangePickerView extends FormFields.BaseInputView
    getTemplate: -> if @model.isCompact() then 'form_fields/date_range_picker_compact' else 'form_fields/date_range_picker'

    getOptions: ->
      options = @model.get('dateRangePickerOptions') or {}

      _.defaults options,
        autoUpdateInput: false
        locale:
          cancelLabel: 'Clear'
          format:      'DD MMMM YYYY'
          firstDay:    1

    onAttach: ->
      @$('input').daterangepicker @getOptions()

      @$('input').on 'apply.daterangepicker',  (event, picker) ->
        range = picker.startDate.format('DD MMMM YYYY') + ' - ' + picker.endDate.format('DD MMMM YYYY')
        $(@).val(range).change()

      @$('input').on 'cancel.daterangepicker', (event, picker) ->
        $(@).val('').change()

    onDestroy: ->
      @$('input').off()
      @$('input').data('daterangepicker').remove()


  # Form fieldset views

  class FormFields.FieldsetView extends App.Views.CompositeView
    template:           'form_fields/fieldset'
    childViewContainer: '.fields'

    attributes: ->
      id:    @model.get('elementId')
      class: 'fieldset-wrapper'
      style: if @model.isShown() then 'display:block;' else 'display:none;'

    ui:
      'fields': '.fields'

    onShow: ->
      @ui.fields.addClass 'row large-up-4' if @model.isCompact()

    getChildView: (model) ->
      return FormFields.TextFieldView              if model.get('tagName') is 'input'  and model.get('type') is 'text'
      return FormFields.NumberFieldView            if model.get('tagName') is 'input'  and model.get('type') is 'number'
      return FormFields.CollectionCheckBoxesView   if model.get('tagName') is 'input'  and model.get('type') is 'collection_check_boxes'
      return FormFields.RadioButtonsView           if model.get('tagName') is 'input'  and model.get('type') is 'radio_buttons'
      return FormFields.CollectionRadioButtonsView if model.get('tagName') is 'input'  and model.get('type') is 'collection_radio_buttons'
      return FormFields.HiddenFieldView            if model.get('tagName') is 'input'  and model.get('type') is 'hidden'
      return FormFields.Select2View                if model.get('tagName') is 'select' and model.get('type') is 'select2'
      return FormFields.Select2AjaxView            if model.get('tagName') is 'select' and model.get('type') is 'select2_ajax'
      return FormFields.Select2MultiView           if model.get('tagName') is 'select' and model.get('type') is 'select2_multi'
      return FormFields.SelectView                 if model.get('tagName') is 'select'
      return FormFields.TextAreaView               if model.get('tagName') is 'textarea'
      return FormFields.DateRangePickerView        if model.get('tagName') is 'input'  and model.get('type') is 'date_range_picker'

    @include 'DynamicFormView'


  class FormFields.FieldsetCollectionView extends App.Views.CollectionView
    childView: FormFields.FieldsetView

    buildChildView: (child, childViewClass, childViewOptions) ->
      new FormFields.FieldsetView
        model:      child
        collection: child.fields
