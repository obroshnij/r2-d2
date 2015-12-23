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
    
    dependenciesAreSatisfied: (fieldValues) ->
      result = _.map @attributes.dependencies, (conditions, parent) =>
        _.map conditions, (allowedValues, checker) =>
          @checkers[checker](allowedValues, fieldValues[parent])

      _.chain(result)
        .flatten()
          .inject (memo, val) -> memo and val
            .value()
            
    hide: ->
      @set 'isShown', false
      
    show: ->
      @set 'isShown', true