@Artoo.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  
  class Views.Fieldset extends App.Views.CompositeView
    template:           'form_fields/fieldset'
    tagName:            'fieldset'
    childViewContainer: '.fields'
    
    attributes: ->
      id: @model.get('elementId')
        
    getChildView: (model) ->
      return Views.TextField            if model.get('tagName') is 'input'  and model.get('type') is 'text'
      return Views.NumberField          if model.get('tagName') is 'input'  and model.get('type') is 'number'
      return Views.CollectionCheckBoxes if model.get('tagName') is 'input'  and model.get('type') is 'collection_check_boxes'
      return Views.RadioButtons         if model.get('tagName') is 'input'  and model.get('type') is 'radio_buttons'
      return Views.Select               if model.get('tagName') is 'select'
      return Views.TextArea             if model.get('tagName') is 'textarea'
    
    onChildviewValueChanged: (childView, args) ->
      @trigger 'value:changed', args
      
    modelEvents:
      'change:isShown' : 'toggle'
      
    toggle: ->
      @$el.show(200) if @model.get('isShown') is true
      @$el.hide(200) if @model.get('isShown') is false
  
  
  class Views.FieldsetCollection extends App.Views.CollectionView
    childView: Views.Fieldset
        
    buildChildView: (child, childViewClass, childViewOptions) ->
      new Views.Fieldset
        model:      child
        collection: child.fields
        
    onChildviewValueChanged: (childView, args) ->
      @trigger 'value:changed', args