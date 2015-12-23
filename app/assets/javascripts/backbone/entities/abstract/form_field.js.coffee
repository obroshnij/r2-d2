@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
    
  class Entities.FormField extends App.Entities.Model
    @include 'DynamicFormElement'
    
    defaults:
      tagName: 'input'
      type:    'text'
    
    mutators:
      elementId: ->
        @get('name') + '_' + @get('tagName')
        
      id: ->
        @get('name')
  
  
  class Entities.FormFields extends App.Entities.Collection
    model: Entities.FormField
  
  
  class Entities.Fieldset extends App.Entities.Model
    @include 'DynamicFormElement'
    
    mutators:
      elementId: ->
        @get('id') + '_fieldset'
    
    initialize: (data) ->
      @initFieldsCollection()
      @storeChildDependencies()
        
      @listenTo @fields, 'change:value',  @onFieldValueChange
      @listenTo @,       'toggle:fields', @toggleFields
      
    storeChildDependencies: ->
      @childDependencies = {}
      @fields.each (field) =>
        _.chain(field.get('dependencies')).keys().each (dependency) =>
          @childDependencies[dependency] ?= []
          @childDependencies[dependency].push field
      
    initFieldsCollection: ->
      @fields = new Entities.FormFields @get('fields')
      @unset 'fields'
      
    toggleFields: (field, fieldValues) ->
      _.chain(@childDependencies[field.get('name')]).each (field) ->
        if field.dependenciesAreSatisfied(fieldValues) then field.show() else field.hide()
      
      if @attributes.dependencies
        if @dependenciesAreSatisfied(fieldValues) then @show() else @hide()
      
    onFieldValueChange: (field) ->
      @trigger 'field:value:changed', field
  
  
  class Entities.Fieldsets extends App.Entities.Collection
    model: Entities.Fieldset
    
    initialize: ->
      @listenTo @, 'field:value:changed', @onFieldValueChange
      
    onFieldValueChange: (field) ->
      fieldValues = @getFieldValues()
      for model in @models
        model.trigger 'toggle:fields', field, fieldValues
        
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