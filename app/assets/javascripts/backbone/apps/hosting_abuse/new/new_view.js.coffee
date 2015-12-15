@Artoo.module 'HostingAbuseApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Layout extends App.Views.LayoutView
    template: 'hosting_abuse/new/layout'
    
    regions:
      formRegion: '#form-region'
        
  class New.NewReport extends App.Views.ItemView
    template: 'hosting_abuse/new/new_report'