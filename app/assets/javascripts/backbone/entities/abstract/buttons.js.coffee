@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Button extends Entities.Model

    defaults:
      buttonType: 'button'

  class Entities.Buttons extends Entities.Collection
    model: Entities.Button

  API =

    getFormButtons: (buttons, model) ->
      buttons = @getDefaultButtons buttons, model

      array = []

      _.flatten([buttons.custom || []]).forEach (custom) ->
        array.push { type: custom.type, className: 'button', text: custom.text, buttonType: 'custom' }

      array.push { type: 'cancel',  className: 'button secondary', text: buttons.cancel                        } unless buttons.cancel  is false
      array.push { type: 'primary', className: 'button',           text: buttons.primary, buttonType: 'submit' } unless buttons.primary is false

      array.reverse() if buttons.placement is 'left'

      buttonsCollection = new Entities.Buttons array
      buttonsCollection.placement = buttons.placement
      buttonsCollection

    getDefaultButtons: (buttons, model) ->
      _.defaults buttons,
        primary:   if model.isNew() then 'Create' else 'Update'
        cancel:    'Cancel'
        placement: 'right'

  App.reqres.setHandler 'form:button:entities', (buttons = {}, model) ->
    API.getFormButtons buttons, model
