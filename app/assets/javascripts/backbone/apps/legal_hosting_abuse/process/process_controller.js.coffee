@Artoo.module 'LegalHostingAbuseApp.Process', (Process, App, Backbone, Marionette, $, _) ->
  
  class Process.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { report } = options
      
      processView = @getProcessView report
        
      form = App.request 'form:component', processView,
        proxy:      'modal'
        model:      report
        saveMethod: 'markProcessed'
        onCancel:  => @region.empty()
        onSuccess: => @region.empty()
      
      @show form
          
    getProcessView: (report) ->
      schema = new Process.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  report