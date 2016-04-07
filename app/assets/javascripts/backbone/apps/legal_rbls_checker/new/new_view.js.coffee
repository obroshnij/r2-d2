@Artoo.module 'LegalRblsCheckerApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'legal_rbls_checker/new/layout'
    
    regions:
      panelRegion:  '#panel-region'
      formRegion:   '#form-region'
      resultRegion: '#result-region'
      
      
  class New.Panel extends App.Views.ItemView
    template: 'legal_rbls_checker/new/panel'
    
    
  class New.FormSchema extends Marionette.Object
    
    form:
      buttons:
        primary: 'Submit'
        cancel:  false
      syncingType: 'buttons'
      
    schema:
      [
        {
          legend: 'IP Check'
          fields: [
            name:  'query'
            label: 'IP Address'
          ]
        }
      ]
      
  
  class New.Result extends App.Views.ItemView
    template:  'legal_rbls_checker/new/_result'
    tagName:   'tr'
    className: -> @model.get('resultColor')
  
  
  class New.Results extends App.Views.CompositeView
    template: 'legal_rbls_checker/new/results'
    
    childView:          New.Result
    childViewContainer: 'tbody'
    
    onDomRefresh: ->
      @$('table').tablesorter
        headers:
          3: sorter: false