@Artoo.module 'ToolsBulkDigApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.LayoutView
    template: 'tools_bulk_dig/new/layout'

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
          legend: 'Bulk dig'
          fields: [
            name:     'query'
            label:    'Query'
            tagName:  'textarea'
            hint:     'Domain names or host names'
          ,
            name:     'record_types'
            label:    'Host Records'
            type:     'collection_check_boxes'
            options:  [
              id: 'a',    name: 'A / CNAME'
            ,
              id: 'aaaa', name: 'AAAA'
            ,
              id: 'mx',   name: 'MX'
            ,
              id: 'txt',  name: 'TXT'
            ,
              id: 'ns',   name: 'NS'
            ,
              id: 'ptr',  name: 'PTR'
            ]
            default: ['a', 'aaaa', 'mx', 'txt', 'ns', 'ptr']
          ,
            name:     'nameservers'
            label:    'Nameservers'
            type:     'collection_radio_buttons'
            options:  [
              id: 'google',   name: 'Google Public DNS'
            ,
              id: 'verisign', name: 'Verisign'
            ,
              id: 'dyn',      name: 'Dyn'
            ,
              id: 'comodo',   name: 'Comodo Secure DNS'
            ,
              id: 'open',     name: 'OpenDNS'
            ]
            default:  'google'
          ]
        }
      ]


  class New.Result extends App.Views.ItemView
    template: 'tools_bulk_dig/new/result'

    modelEvents:
      'sync:stop' : 'render'

    onAttach: ->
      @destroy() unless @model.get('records')
