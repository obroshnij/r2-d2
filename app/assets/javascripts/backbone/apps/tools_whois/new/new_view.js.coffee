@Artoo.module 'ToolsWhoisApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'tools_whois/new/layout'
    
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
          legend: 'Whois lookup'
          fields: [
            name:  'query'
            label: 'Query'
            hint:  'Domain name, IP address or TLD'
          ]
        }
      ]
      
  
  class New.Result extends App.Views.ItemView
    template: 'tools_whois/new/result'
    
    modelEvents:
      'sync:stop' : 'render'
      
    onAttach: ->
      @destroy() unless @model.get('record')