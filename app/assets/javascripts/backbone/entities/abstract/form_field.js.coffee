@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  CHECKERS =
    
    value: (allowed, current) ->
      allowed      = _.flatten [allowed]
      current      = _.flatten [current]
      intersection = _.intersection allowed, current
      not _.isEmpty(intersection)
      
    notExactValue: (allowed, current) ->
      allowed      = _.flatten [allowed]
      current      = _.flatten [current]
      not _.isEqual(_.compact(current), allowed)
  
  
  class Entities.FormField extends App.Entities.Model
    
    mutators:
      
      elementId: ->
        @get('name') + '_' + @get('tagName')
        
      id: ->
        @get('name')
        
    defaults: ->
      tagName: 'input'
      type:    'text'
      isShown: true
    
    dependenciesAreSatisfied: (fieldValues) ->
      result = _.map @attributes.dependencies, (conditions, parent) ->
        _.map conditions, (allowedValues, checker) ->
          CHECKERS[checker](allowedValues, fieldValues[parent])

      _.chain(result)
        .flatten()
          .inject (memo, val) -> memo and val
            .value()
  
  class Entities.FormFields extends App.Entities.Collection
    model: Entities.FormField
  
  
  class Entities.Fieldset extends App.Entities.Model
    
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
      if @attributes.dependencies
        if @dependenciesAreSatisfied(fieldValues) then @set('isShown', true) else @set('isShown', false)
      _.chain(@childDependencies[field.get('name')]).each (field) ->
        if field.dependenciesAreSatisfied(fieldValues) then field.set('isShown', true) else field.set('isShown', false)
      
    onFieldValueChange: (field) ->
      @trigger 'field:value:changed', field
        
    mutators:
      
      elementId: ->
        @get('id') + '_fieldset'
        
    defaults:
      isShown: true
    
    dependenciesAreSatisfied: (fieldValues) ->
      result = _.map @attributes.dependencies, (conditions, parent) ->
        _.map conditions, (allowedValues, checker) ->
          CHECKERS[checker](allowedValues, fieldValues[parent])

      _.chain(result)
        .flatten()
          .inject (memo, val) -> memo and val
            .value()
    
  class Entities.Fieldsets extends App.Entities.Collection
    model: Entities.Fieldset
    
    initialize: ->
      @listenTo @, 'field:value:changed', @onFieldValueChange
      @listenTo @, 'reset',               @storeChildDependencies
      
    storeChildDependencies: ->
      @childDependencies = {}
      @models.each (fieldset) =>
        _.chain(fieldset.get('dependencies')).keys().each (dependency) =>
          @childDependencies[dependency] ?= []
          @childDependencies[dependency].push fieldset
      
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