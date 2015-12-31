@Artoo.module 'Components.FormFields', (FormFields, App, Backbone, Marionette, $, _) ->
  
  class FormFields.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { @schema } = options
      
      @model = @getModel options
      
      @formFields = @getFormFields()
      @fieldsView = @getFieldsView()
      
      @createListeners()
      
    getModel: (options) ->
      options.model or App.request('new:model')
      
    getFormFields: ->
      fields = App.request 'init:form:fieldset:entities', _.result(@schema, 'schema')
    
      fields.each (fieldset) =>
        fieldset.fields.each (field) =>
          val = @model.get field.get('name')
          field.set 'value', val if val
        
      fields.trigger 'field:value:changed'
      
      fields
      
    getFieldsView: ->
      view = new FormFields.FieldsetCollectionView
        collection: @formFields
        
      view.form = _.result @schema, 'form'
      
      view
      
    createListeners: ->
      @listenTo @fieldsView, 'childview:childview:value:changed', @forwardChangeEvent
      @listenTo @fieldsView, 'destroy', -> @schema.destroy()
      
    forwardChangeEvent: (fieldsetView, inputView, fieldName, fieldValue) ->
      eventName = s.replaceAll(fieldName, '[^a-zA-Z0-9]', ':') + ':change'
      
      @schema.triggerMethod eventName, fieldValue
      @formFields.trigger   'field:value:changed'
  
  
  App.reqres.setHandler 'form:fields:component', (options) ->
    throw new Error "Form Fields Component requires a schema to be passed in" if not options.schema
        
    controller = new FormFields.Controller options
    controller.fieldsView