@Artoo.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

  Concerns.DynamicFormView =

    modelEvents:
      'change:isShown' : 'toggle'

    toggle: ->
      @$el.show(200) if @model.isShown()
      @$el.hide(200) if @model.isHidden()
