@Artoo.module 'Components.Form', (Form, App, Backbone, Marionette, $, _) ->
  
  class Form.FieldsController extends Marionette.Object
    
    manage: (contentView) ->
      @contentView = contentView
      
      @listenTo contentView, 'destroy', @destroy
      @listenTo contentView, 'value:changed', @forwardEvent
      
    forwardEvent: (args) ->
      rowId     = args.view.attributes().id
      eventName = s.replaceAll rowId, '[^a-zA-Z0-9]', ':'
      value     = args.view.currentValue()

      @triggerMethod eventName, value