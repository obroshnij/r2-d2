@Artoo.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  
  class Views.BaseInput extends App.Views.ItemView
    template: 'form_fields/input'
    
    attributes: ->
      class: 'row'
      id:    @model.get('elementId')
    
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
  
  
  class Views.TextField extends Views.BaseInput
  
  
  class Views.NumberField extends Views.BaseInput
  
        
  class Views.Select extends Views.BaseInput
    template: 'form_fields/select'