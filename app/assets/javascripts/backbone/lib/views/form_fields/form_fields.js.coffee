@Artoo.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  
  class Views.FormFields extends App.Views.LayoutView
    template: 'form_fields/layout'
      
    regions:
      formFieldsRegion: '#form-fields-region'
        
    initialize: (options) ->
      schema  = _.result @, 'schema'
      @fields = App.request 'init:form:fieldset:entities', schema
        
    onShow: ->
      fieldsetCollectionView = @getFieldsetCollectionView @fields
      
      @listenTo fieldsetCollectionView, 'childview:value:changed', (view, fieldName, fieldValue) ->
        @triggerChangeEvent fieldName, fieldValue
      
      @formFieldsRegion.show fieldsetCollectionView
      
    getFieldsetCollectionView: (fields) ->
      new Views.FieldsetCollection
        collection: fields
      
    getOptions: (collection) ->
      collection.map (item) -> item.attributes
    
    triggerChangeEvent: (fieldName, fieldValue) ->
      eventName = s.replaceAll(fieldName, '[^a-zA-Z0-9]', ':') + ':change'
      
      @triggerMethod eventName, fieldValue