@Artoo.module 'HostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'hosting_abuse/new/layout'
    
    regions:
      formRegion: '#form-region'
  
  
  class New.FormFields extends App.Views.Form.FieldsView