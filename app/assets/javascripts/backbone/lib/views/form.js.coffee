@Artoo.module 'Views.Form', (Form, App, Backbone, Marionette, $, _) ->
  
  class Form.Input extends App.Views.ItemView
    template: 'form/form_input'
    
    attributes: ->
      class: 'row'
      id:    @model.get('fieldId')
    
    ui: ->
      input: "#{@getTagName()}[name='#{@getNameAttr()}']"
      
    getTagName: ->
      @model.get('tagName')
      
    getNameAttr: ->
      @model.get('name')
    
    triggers:
      'change @ui.input' : 'value:changed'
      
    currentValue: ->
      @ui.input.val()
  
  
  class Form.TextField extends Form.Input
  
  
  class Form.NumberField extends Form.Input
  
        
  class Form.Select extends Form.Input
    template: 'form/form_select'
  
        
  class Form.Fieldset extends App.Views.CompositeView
    template:           'form/form_fieldset'
    tagName:            'fieldset'
    childViewContainer: '.fields'
    
    attributes: ->
      id: @model.get('fieldsetId')
        
    getChildView: (model) ->
      return Form.TextField   if model.get('tagName') is 'input'  and model.get('type') is 'text'
      return Form.NumberField if model.get('tagName') is 'input'  and model.get('type') is 'number'
      return Form.Select      if model.get('tagName') is 'select'
    
    onChildviewValueChanged: (childView, args) ->
      @trigger 'value:changed', args
  
  
  class Form.FieldsView extends App.Views.CollectionView
    childView: Form.Fieldset
    
    buildChildView: (child, childViewClass, childViewOptions) ->
      new Form.Fieldset
        model:      child
        collection: child.fields
        
    onChildviewValueChanged: (childView, args) ->
      @trigger 'value:changed', args