@Artoo.module 'ToolsListsDiffApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'tools_lists_diff/new/layout'
    
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
          legend: 'Lists difference'
          fields: [
            name:    'query_one'
            label:   'List 1'
            tagName: 'textarea'
          ,
            name:    'query_two'
            label:   'List 2'
            tagName: 'textarea'
          ]
        }
      ]
      
  
  class New.Result extends App.Views.ItemView
    template: 'tools_lists_diff/new/result'
    
    modelEvents:
      'sync:stop' : 'render'
      
    onAttach: ->
      @destroy() unless @model.get('list_one') && @model.get('list_two')
      
    @include 'HasDropdowns'