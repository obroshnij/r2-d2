@Artoo.module 'Components.FormFields', (FormFields, App, Backbone, Marionette, $, _) ->
  
  class FormFields.Controller extends App.Controllers.Application
    
    defaults: ->
      compact: false
      proxy:   false
    
    initialize: (options) ->
      { @schema, proxy } = options
      
      @model = @getModel options
      
      @formFields = @getFormFields()
      @fieldsView = @getFieldsView()
      
      @parseProxys proxy if proxy
      @createListeners()
      
    getModel: (options) ->
      options.model or App.request('new:model')
      
    getFormFields: ->
      fields = App.request 'init:form:fieldset:entities', _.result(@schema, 'schema')
      
      App.execute 'when:synced', @model, =>
      
        fields.each (fieldset) =>
          fieldset.fields.each (field) =>
            val = field.get('value') or @getValueFromModel(field.get('name')) or field.get('default')
            field.set 'value', val
        
        fields.trigger 'field:value:changed'
      
      fields
      
    getValueFromModel: (name) ->
      path = _.compact name.split(/[\[\]]/)
      
      val = if path.length is 1
        @model.get name
      else if path.length > 1
        _.reduce _.without(path, path[0]), ((obj, key) -> obj?[key]), @model.get(path[0])
        
      val = val.toString() if _.isBoolean(val)
      
      val
      
    getFieldsView: ->
      view = new FormFields.FieldsetCollectionView
        collection: @formFields
        
      view.form = _.result @schema, 'form'
      
      view
      
    parseProxys: (proxys) ->
      for proxy in _([proxys]).flatten()
        @fieldsView[proxy] = _.result @schema, proxy
      
    createListeners: ->
      @listenTo @fieldsView, 'childview:childview:value:changed', @forwardChangeEvent
      @listenTo @fieldsView, 'show',    -> @schema.triggerMethod 'show', @fieldsView
      @listenTo @fieldsView, 'show',    => Backbone.Syphon.deserialize @fieldsView, @formFields.getFieldValues()
      @listenTo @fieldsView, 'destroy', -> @schema.destroy()
      @listenTo @fieldsView, 'destroy', -> @destroy()
      
    forwardChangeEvent: (fieldsetView, inputView, fieldName, fieldValue) ->
      eventName = s.replaceAll(fieldName, '[^a-zA-Z0-9]', ':') + ':change'
      
      @schema.triggerMethod eventName, fieldValue, @fieldsView
      @formFields.trigger   'field:value:changed'
  
  
  App.reqres.setHandler 'form:fields:component', (options) ->
    throw new Error "Form Fields Component requires a schema to be passed in" if not options.schema
        
    controller = new FormFields.Controller options
    controller.fieldsView