@Artoo.module 'LegalHostingAbuseApp.List', (List, App, Backbone, Marionette, $, _) ->
  
  class List.Layout extends App.Views.LayoutView
    template: 'legal_hosting_abuse/list/layout'
    
    regions:
      panelRegion:   '#panel-region'
      reportsRegion: '#reports-region'
      
  class List.Panel extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/panel'
    
    triggers:
      'click a' : 'submit:report:clicked'
    
  class List.Reports extends App.Views.ItemView
    template: 'legal_hosting_abuse/list/reports'