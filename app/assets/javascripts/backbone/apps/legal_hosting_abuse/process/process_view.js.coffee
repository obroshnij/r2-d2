@Artoo.module 'LegalHostingAbuseApp.Process', (Process, App, Backbone, Marionette, $, _) ->
  
  class Process.Form extends Marionette.ItemView
    template: 'legal_hosting_abuse/process/form'
    
    modal:
      title: 'Process Hosting Abuse'