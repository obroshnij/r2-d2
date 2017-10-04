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
      @model.get 'identifier'

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

    modelEvents:
      'change:isShown' : 'toggle'
      'enable:input'   : 'enableInput'
      'disable:input'  : 'disableInput'

    enableInput: (val) ->
      @ui.input.attr('disabled', false)
      @ui.input.val(val) unless _.isUndefined(val)

    disableInput: (val) ->
      @ui.input.attr('disabled', true)
      @ui.input.val(val) unless _.isUndefined(val)


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
      'change:isShown'   : 'toggle'
      'enable:options'   : 'enableOptions'
      'disable:options'  : 'disableOptions'
      'unselect:current' : 'unselectCurrent'

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

    unselectCurrent: ->
      $(this.ui.input).val('')


  class FormFields.Select2View extends FormFields.SelectView

    onShow: ->
      @$('select').select2()
      @$('select').on 'select2:open', =>


    onDestroy: ->
      @$('select').off()
      try
        @$('select').select2 'destroy'
      catch err
        null


  class FormFields.Select2AjaxView extends FormFields.SelectView

    onShow: ->
      @$('select').select2
        ajax:
          url:      @model.get('url')
          dataType: 'json'
          type:     'GET'
          delay:    250
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

    getResultsHandler: ->
      @model.get('dateRangePickerHandler') or () ->

    onAttach: ->
      @$('input').daterangepicker(@getOptions(), @getResultsHandler())

      @$('input').on 'apply.daterangepicker',  (event, picker) ->
        if picker.singleDatePicker
          date = picker.startDate.format('DD MMMM YYYY')
          $(@).val(date).change()
        else
          range = picker.startDate.format('DD MMMM YYYY') + ' - ' + picker.endDate.format('DD MMMM YYYY')
          $(@).val(range).change()

      @$('input').on 'cancel.daterangepicker', (event, picker) ->
        $(@).val('').change()

    onDestroy: ->
      @$('input').off()
      @$('input').data('daterangepicker').remove()


  class FormFields.GroupView extends App.Views.CompositeView
    template:           'form_fields/form_group'
    childViewContainer: '.fields'

    attributes: ->
      class: if @model.get('isFirst') then 'form-group no-border' else 'form-group'

    ui:
      'fields': '.fields'

    onShow: ->
      @ui.fields.addClass 'row large-up-4' if @model.get('isCompact')

    events:
      'click .remove-group' : 'onRemoveClick'

    modelEvents:
      'mark:for:destruction' : 'render'

    onRemoveClick: (event) ->
      @$el.hide 200, () => @model.trigger 'mark:for:destruction'

    getChildView: (m) ->
      return FormFields.TextFieldView              if m.get('tagName') is 'input'  and m.get('type') is 'text'
      return FormFields.NumberFieldView            if m.get('tagName') is 'input'  and m.get('type') is 'number'
      return FormFields.CollectionCheckBoxesView   if m.get('tagName') is 'input'  and m.get('type') is 'collection_check_boxes'
      return FormFields.RadioButtonsView           if m.get('tagName') is 'input'  and m.get('type') is 'radio_buttons'
      return FormFields.CollectionRadioButtonsView if m.get('tagName') is 'input'  and m.get('type') is 'collection_radio_buttons'
      return FormFields.HiddenFieldView            if m.get('tagName') is 'input'  and m.get('type') is 'hidden'
      return FormFields.Select2View                if m.get('tagName') is 'select' and m.get('type') is 'select2'
      return FormFields.Select2AjaxView            if m.get('tagName') is 'select' and m.get('type') is 'select2_ajax'
      return FormFields.Select2MultiView           if m.get('tagName') is 'select' and m.get('type') is 'select2_multi'
      return FormFields.SelectView                 if m.get('tagName') is 'select'
      return FormFields.TextAreaView               if m.get('tagName') is 'textarea'
      return FormFields.DateRangePickerView        if m.get('tagName') is 'input'  and m.get('type') is 'date_range_picker'


  # Form fieldset views

  class FormFields.FieldsetView extends App.Views.CompositeView
    template:           'form_fields/fieldset'
    childView:          FormFields.GroupView
    childViewContainer: '.form-groups'

    attributes: ->
      id:    @model.get('elementId')
      class: 'fieldset-wrapper'
      style: if @model.isShown() then 'display:block;' else 'display:none;'

    buildChildView: (child, childViewClass, childViewOptions) ->
      new FormFields.GroupView
        model:      child
        collection: child.fields

    events:
      'click .add-group' : 'onAddClick'

    onAddClick: (event) ->
      @model.trigger 'add:group'

    onShow: ->
      @updateRemoveButtons()

    collectionEvents:
      'mark:for:destruction' : 'updateBorders updateRemoveButtons'
      'update'               : 'updateRemoveButtons'

    updateBorders: ->
      @$('.form-group.no-border').removeClass('no-border')
      @$('.form-group:visible:first').addClass('no-border')

    updateRemoveButtons: ->
      if @collection.filter((g) => !g.get('markedForDestruction')).length is 1
        @$('.remove-group.nested-fields-button').addClass('hidden')
      else
        @$('.remove-group.nested-fields-button').removeClass('hidden')

    # attachHtml: (collectionView, childView, index) ->
    #   if collectionView.isBuffering
    #     collectionView._bufferedChildren.splice(index, 0, childView)
    #     return
    #
    #   if !collectionView._insertBefore(childView, index)
    #     $childEl = $(childView.el)
    #     $childEl.hide()
    #     { $el, $childViewContainer } = collectionView
    #     ($childViewContainer or $el).append $childEl[0]
    #     $childEl.show 200

    @include 'DynamicFormView'

  class FormFields.FieldsetCollectionView extends App.Views.CollectionView
    childView: FormFields.FieldsetView

    buildChildView: (child, childViewClass, childViewOptions) ->
      new FormFields.FieldsetView
        model:      child
        collection: child.groups
