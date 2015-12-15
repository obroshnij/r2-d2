@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.FormField extends App.Entities.Model
    
    defaults:
      tagName: 'input'
      type:    'text'
      
  class Entities.FormFieldSet extends App.Entities.Collection
    model: Entities.FormField