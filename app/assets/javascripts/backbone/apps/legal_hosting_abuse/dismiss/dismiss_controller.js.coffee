@Artoo.module 'LegalHostingAbuseApp.Dismiss', (Dismiss, App, Backbone, Marionette, $, _) ->
  
  class Dismiss.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { report } = options
      
      dismissView = @getDismissView report
      
      form = App.request 'form:component', dismissView,
        proxy:      'modal'
        model:      report
        saveMethod: 'markDismissed'
        onCancel:  => @region.empty()
        onSuccess: => @region.empty()
      
      @show form
          
    getDismissView: (report) ->
      schema = new Dismiss.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  report