@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.FormField extends App.Entities.Model
      
    mutators:
      
      fieldId: ->
        @get('name') + '_' + @get('tagName')
        
    defaults:
      tagName: 'input'
      type:    'text'
  
  
  class Entities.FormFieldCollection extends App.Entities.Collection
    model: Entities.FormField
  
  
  class Entities.Fieldset extends App.Entities.Model
    
    initialize: (data) ->
      fields = @get 'fields'
      if fields
        @fields = new Entities.FormFieldCollection fields
        @unset 'fields'
        
    mutators:
      
      fieldsetId: ->
        @get('id') + '-fieldset'
    
  class Entities.FieldsetCollection extends App.Entities.Collection
    model: Entities.Fieldset