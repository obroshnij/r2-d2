@Artoo.module 'Behaviors', (Behaviors, App, Backbone, Marionette, $, _) ->
  
  class Behaviors.TestBehavior extends Marionette.Behavior
    
    onRender: ->
      console.log 'inside behaviours on render'