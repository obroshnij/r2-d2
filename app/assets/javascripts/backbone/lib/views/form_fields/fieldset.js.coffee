@Artoo.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  
  class Views.Fieldset extends App.Views.CompositeView
    template:           'form_fields/fieldset'
    tagName:            'fieldset'
    childViewContainer: '.fields'
    
    attributes: ->
      id: @model.get('elementId')
        
    getChildView: (model) ->
      return Views.TextField   if model.get('tagName') is 'input'  and model.get('type') is 'text'
      return Views.NumberField if model.get('tagName') is 'input'  and model.get('type') is 'number'
      return Views.Select      if model.get('tagName') is 'select'
    
    onChildviewValueChanged: (childView, args) ->
      @trigger 'value:changed', args
  
  
  class Views.FieldsetCollection extends App.Views.CollectionView
    childView: Views.Fieldset
        
    buildChildView: (child, childViewClass, childViewOptions) ->
      new Views.Fieldset
        model:      child
        collection: child.fields
        
    onChildviewValueChanged: (childView, args) ->
      @trigger 'value:changed', args