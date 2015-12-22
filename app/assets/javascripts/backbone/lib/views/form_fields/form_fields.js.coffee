@Artoo.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  
  class Views.FormFields extends App.Views.LayoutView
    template: 'form_fields/layout'
      
    regions:
      formFieldsRegion: '#form-fields-region'
        
    initialize: (options) ->
      schema  = _.result @, 'schema'
      @fields = App.request 'init:form:fieldset:entities', schema
      window.fields = @fields
        
    onShow: ->
      fieldsetCollectionView = @getFieldsetCollectionView @fields
      @formFieldsRegion.show fieldsetCollectionView
      # @$("input, select, textarea").change()
      
    getFieldsetCollectionView: (fields) ->
      new Views.FieldsetCollection
        collection: fields
      
    getOptions: (collection) ->
      collection.map (item) -> item.attributes
    
    # fieldValues: ->
    #   Backbone.Syphon.serialize @el
    #
    # onChildviewValueChanged: (childview, args) ->
    #   fieldName = args.model.get 'name'
    #   newValue  = args.view.currentValue()
    #
    #   @triggerChangeEvent    fieldName, newValue
    #   @updateDependentFields fieldName
    #
    # triggerChangeEvent: (fieldName, newValue) ->
    #   eventName = s.replaceAll(fieldName, '[^a-zA-Z0-9]', ':') + ':change'
    #
    #   @triggerMethod eventName, newValue
    #
    # updateDependentFields: (fieldName) ->
    #   fieldValues = @fieldValues()
    #   _.each @dependentElements(fieldName), (element) =>
    #     selector = element.get 'elementId'
    #     if element.dependenciesAreSatisfied(fieldValues) then @show("##{selector}") else @hide("##{selector}")
    #
    # hide: (selector) ->
    #   if @_isShown then @$(selector).hide(200) else @$(selector).css('display', 'none')
    #
    # show: (selector) ->
    #   if @_isShown then @$(selector).show(200) else @$(selector).css('display', 'none')
    #   @$(selector).find('input, select, textarea').change() if s.endsWith(selector, 'fieldset')
    #
    # dependentElements: (fieldName) ->
    #   _.union @_dependentFieldsets(fieldName), @_dependentFormFields(fieldName)
    #
    # _dependentFieldsets: (fieldName) ->
    #   @fields
    #     .chain()
    #       .map (fieldset) -> fieldset if fieldset.dependsOn(fieldName)
    #         .compact()
    #           .value()
    #
    # _dependentFormFields: (fieldName) ->
    #   @fields
    #     .chain()
    #       .map (fieldset) -> fieldset.fields.models
    #         .flatten()
    #           .map (formField) -> formField if formField.dependsOn(fieldName)
    #             .compact()
    #               .value()