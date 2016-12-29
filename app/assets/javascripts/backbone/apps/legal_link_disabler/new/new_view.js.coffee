@Artoo.module 'LegalLinkDisablerApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'legal_link_disabler/new/layout'

    regions:
      formRegion:   '#form-region'
      resultRegion: '#result-region'


  class New.FormSchema extends Marionette.Object

    form:
      buttons:
        primary: 'Submit'
        cancel:  false
      syncingType: 'buttons'

    schema:
      [
        {
          legend: 'Link Disabler'
          fields: [
            name:     'links'
            label:    'Links'
            tagName:  'textarea'
          ,
            name:    'mode'
            label:   'Mode'
            type:    'collection_radio_buttons'
            options:  [{ id: 'auto', name: 'Auto Detect' }, { id: 'encode', name: 'Encode' }, { id: 'decode', name: 'Decode' }]
            default: 'auto'
          ]
        }
      ]

  class New.Result extends App.Views.ItemView
    template: 'legal_link_disabler/new/result'

    onAttach: ->
      @destroy() unless @model.get('links')?.length
