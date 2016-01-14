@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
  
  Concerns.DynamicFormElement =
    
    defaults:
      isShown: true
    
    checkers:
    
      value: (allowed, current) ->
        allowed      = _.flatten [allowed]
        current      = _.flatten [current]
        intersection = _.intersection allowed, current
        not _.isEmpty(intersection)
        
    initialize: ->
      @listenTo @, 'toggle:fields', @toggle
    
    dependenciesAreSatisfied: (fieldValues) ->
      return true                               unless  @attributes.dependencies
      return @_verifyDependencies(fieldValues)  if      _.isArray  @attributes.dependencies
      return @_verifyDependency(fieldValues)    if      _.isObject @attributes.dependencies
      
    _verifyDependencies: (fieldValues) ->
      result = _.map @attributes.dependencies, (dependency) =>
        @_verifyDependency(fieldValues, dependency)
        
      _.chain(result)
        .inject (memo, val) -> memo or val
          .value()
      
    _verifyDependency: (fieldValues, dependency) ->
      dependency ?= @attributes.dependencies
      
      result = _.map dependency, (conditions, parent) =>
        _.map conditions, (allowedValues, checker) =>
          @checkers[checker](allowedValues, fieldValues[parent])

      _.chain(result)
        .flatten()
          .inject (memo, val) -> memo and val
            .value()
    
    toggle: (fieldValues) ->
      if @dependenciesAreSatisfied(fieldValues) then @show() else @hide()
            
    show: ->
      @set 'isShown', true  if @isHidden()
    
    isShown: ->
      @get 'isShown'
      
    hide: ->
      @set 'isShown', false if @isShown()
      
    isHidden: ->
      not @isShown()
      
    isCompact: ->
      @get 'isCompact'