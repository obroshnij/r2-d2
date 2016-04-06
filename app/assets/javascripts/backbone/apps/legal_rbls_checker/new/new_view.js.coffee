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
            name:  'ip_address'
            label: 'IP Address'
          ]
        }
      ]