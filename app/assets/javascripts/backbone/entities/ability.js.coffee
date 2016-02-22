@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Rule extends App.Entities.Model
  
  
  class Entities.Ability extends App.Entities.Collection
    model: Entities.Rule
    
    can: (action, subject) ->
      rule = @filter (rule) =>
        @checkSubject(rule, subject) and @checkAction(rule, action)
      _.size(rule) isnt 0
      
    checkSubject: (rule, subject) ->
      return true if _.contains rule.get('subjects'), 'All'
      _.contains rule.get('subjects'), subject
      
    checkAction: (rule, action) ->
      return true if _.contains rule.get('actions'), 'manage'
      _.contains rule.get('actions'), action
    
    cannot: (action, subject) ->
      not @can action, subject
  
  
  API =
    
    newAbility: (attrs = {}) ->
      new Entities.Ability attrs
  
  
  App.reqres.setHandler 'new:ability:entity', (attrs = {}) ->
    API.newAbility attrs