@Artoo.module 'ToolsDataExtractorApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'tools_data_extractor/new/layout'

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
          legend: 'Data search'
          fields: [
            name:    'query'
            label:   'Text'
            hint:    'Text/copy-paste containing items that should be extracted'
            tagName: 'textarea'
          ,
            name:    'object_type'
            label:   'Look for'
            type:    'collection_radio_buttons'
            options: _.map App.Entities.DataSearch.prototype.objectTypes, (val, key) -> { id: key, name: val }
            default: 'domain'
          ,
            name:    'internal'
            label:   'Internal domains'
            hint:    'Keep or remove internal domains from the parsed list'
            type:    'radio_buttons'
            options: [{ id: 'remove', name: 'Remove' }, { id: 'keep', name: 'Keep' }]
            default: 'remove'
            dependencies:
              object_type: value: ['domain', 'host', 'email']
          ]
        }
      ]


  class New.Result extends App.Views.ItemView
    template: 'tools_data_extractor/new/result'

    modelEvents:
      'sync:stop' : 'render'

    serializeData: ->
      data = super
      data.message = @getMessage() if @model.get('internal_items').length
      data

    getMessage: ->
      message = 'Internal domains '

      if @model.get('internal') is 'remove'
        message += 'removed from'
      else
        message += 'found in'

      message += ' the list!'
