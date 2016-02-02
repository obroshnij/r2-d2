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
      input: "#{@getTagName()}[name^='#{@getNameAttr()}']"
      
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
  
  
  class FormFields.CollectionCheckBoxesView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/collection_check_boxes'
    
  
  class FormFields.RadioButtonsView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/radio_buttons'
  
  
  class FormFields.CollectionRadioButtonsView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/collection_radio_buttons'
    
  
  class FormFields.HiddenFieldView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/hidden'
    
    
  class FormFields.DateRangePickerView extends FormFields.BaseInputView
    getTemplate: -> 'form_fields/date_range_picker'
    
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