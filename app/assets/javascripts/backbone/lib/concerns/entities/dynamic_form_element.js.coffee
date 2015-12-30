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
      
      notExactValue: (allowed, current) ->
        allowed      = _.flatten [allowed]
        current      = _.flatten [current]
        not _.isEqual(_.compact(current), allowed)
        
    initialize: ->
      @listenTo @, 'toggle:fields', @toggle
    
    dependenciesAreSatisfied: (fieldValues) ->
      return true unless @attributes.dependencies
      
      result = _.map @attributes.dependencies, (conditions, parent) =>
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