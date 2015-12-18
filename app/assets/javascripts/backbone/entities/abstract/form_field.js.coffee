@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  CHECKERS =
    
    value: (allowed, current) ->
      _.contains _.flatten([allowed]), current
  
  
  class Entities.FormField extends App.Entities.Model
      
    mutators:
      
      elementId: ->
        @get('name') + '_' + @get('tagName')
        
      id: ->
        @get('name')
        
    defaults:
      tagName: 'input'
      type:    'text'
      
    dependsOn: (formField) ->
      !!@attributes.dependencies and !!@attributes.dependencies[formField]
      
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
      fields = @get 'fields'
      if fields
        @fields = new Entities.FormFields fields
        @unset 'fields'
        
    mutators:
      
      elementId: ->
        @get('id') + '-fieldset'
        
    dependsOn: (formField) ->
      !!@attributes.dependencies and !!@attributes.dependencies[formField]
      
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
  
  
  API = 
    
    newFieldsets: (params) ->
      new Entities.Fieldsets params
  
  
  App.reqres.setHandler 'init:form:fieldset:entities', (params) ->
    API.newFieldsets params