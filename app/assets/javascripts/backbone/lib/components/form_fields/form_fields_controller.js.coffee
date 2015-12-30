@Artoo.module 'Components.FormFields', (FormFields, App, Backbone, Marionette, $, _) ->
  
  class FormFields.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { @schema, @model } = options
      
      @formFields = @getFormFields()
      
      @fieldsView = new FormFields.FieldsetCollectionView
        collection: @formFields
      
      @createListeners()
      
    getFormFields: ->
      fields = App.request 'init:form:fieldset:entities', _.result(@schema, 'schema')
    
      fields.each (fieldset) =>
        fieldset.fields.each (field) =>
          val = @model.get field.get('name')
          field.set 'value', val if val
        
      fields.trigger 'field:value:changed'
      
      fields
      
    createListeners: ->
      @listenTo @fieldsView, 'childview:childview:value:changed', @forwardChangeEvent
      @listenTo @fieldsView, 'destroy', -> @schema.destroy()
      
    forwardChangeEvent: (fieldsetView, inputView, fieldName, fieldValue) ->
      eventName = s.replaceAll(fieldName, '[^a-zA-Z0-9]', ':') + ':change'
      
      @schema.triggerMethod eventName, fieldValue
      @formFields.trigger   'field:value:changed'
  
  
  App.reqres.setHandler 'form:fields:component', (options) ->
    throw new Error "Form Fields Component requires a schema and a model to be passed in" if not options.schema or not options.model
        
    controller = new FormFields.Controller options
    controller.fieldsView