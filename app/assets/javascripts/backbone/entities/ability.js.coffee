@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Rule extends App.Entities.Model
  
  
  class Entities.Ability extends App.Entities.Collection
    model: Entities.Rule
    
    can: (action, subject) ->
      rule = @filter (rule) =>
        @checkSubject(rule, subject) and @checkAction(rule, action) and @checkConditions(rule, subject)
      _.size(rule) isnt 0
      
    checkSubject: (rule, subject) ->
      return true if _.contains rule.get('subjects'), 'All'
      
      _.contains(rule.get('subjects'), subject) or _.contains(rule.get('subjects'), subject.resourceName)
      
    checkAction: (rule, action) ->
      return true if _.contains rule.get('actions'), 'manage'
      
      _.contains rule.get('actions'), action
      
    checkConditions: (rule, subject) ->
      return true if _.isString subject
      return true if _.size(rule.get('conditions')) is 0
      
      _.every rule.get('conditions'), (val, key) ->
        if _.isArray(val)
          _.contains val, subject.get(key)
        else
          subject.get(key) is val
    
    cannot: (action, subject) ->
      not @can action, subject
  
  
  API =
    
    newAbility: (attrs = {}) ->
      new Entities.Ability attrs
  
  
  App.reqres.setHandler 'new:ability:entity', (attrs = {}) ->
    API.newAbility attrs