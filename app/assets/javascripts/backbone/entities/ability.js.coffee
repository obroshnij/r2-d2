@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Rule extends App.Entities.Model
    
  
  class Entities.Ability extends App.Entities.Collection
    model: Entities.Rule
    
    can: (action, subject) ->
      rule = @filter (rule) ->
        _.contains(rule.get('subjects'), subject) and _.contains(rule.get('actions'), action)
      _.size(rule) isnt 0
    
    cannot: (action, subject) ->
      not @can action, subject
  
  
  API =
    
    newAbility: (attrs = {}) ->
      new Entities.Ability attrs
  
  
  App.reqres.setHandler 'new:ability:entity', (attrs = {}) ->
    API.newAbility attrs