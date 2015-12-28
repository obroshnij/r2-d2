@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
  
  Concerns.SelectMe =
    
    initialize: ->
      Backbone.Select.Me.applyTo @
    
  Concerns.SelectOne =
    
    beforeIncluded: (klass, concern) ->
      klass::model.include 'SelectMe'
    
    initialize: (models, options) ->
      Backbone.Select.One.applyTo @, models, options