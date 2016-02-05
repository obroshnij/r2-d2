@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.FormField extends App.Entities.Model
    
    defaults:
      tagName: 'input'
      type:    'text'
    
    mutators:
      elementId: ->
        @get('name') + '_' + @get('tagName')
        
      id: ->
        @get('name')
        
      columnClass: ->
        if @get('hasHint') then 'large-5' else 'large-12'
        
    @include 'DynamicFormElement'
  
  
  class Entities.FormFields extends App.Entities.Collection
    model: Entities.FormField
  
  
  class Entities.Fieldset extends App.Entities.Model
    
    defaults:
      isCompact: false
      hasHints:  true
    
    mutators:
      elementId: ->
        @get('id') + '_fieldset' if @get('id')
    
    initialize: ->
      @fields = new Entities.FormFields @get('fields')
      @fields.each (field) => field.set 'isCompact', @get('isCompact')
      @fields.each (field) => field.set 'hasHint',   @get('hasHints')
      @unset 'fields'
    
    toggle: (fieldValues) ->
      @fields.each (field) -> field.trigger 'toggle:fields', fieldValues
      
    @include 'DynamicFormElement'
  
  
  class Entities.Fieldsets extends App.Entities.Collection
    model: Entities.Fieldset
    
    initialize: ->
      @listenTo @, 'field:value:changed', @onFieldValueChange
      
    onFieldValueChange: ->
      fieldValues = @getFieldValues()
      model.trigger 'toggle:fields', fieldValues for model in @models
        
    getFieldValues: ->
      result = {}
      fields = _.chain(@models).map((fieldset) -> fieldset.fields.models).flatten().value()
      _(fields).each (field) -> result[field.get('name')] = field.get('value')
      result
    
  
  API = 
    
    newFieldsets: (params) ->
      new Entities.Fieldsets params
  
  
  App.reqres.setHandler 'init:form:fieldset:entities', (params) ->
    API.newFieldsets params