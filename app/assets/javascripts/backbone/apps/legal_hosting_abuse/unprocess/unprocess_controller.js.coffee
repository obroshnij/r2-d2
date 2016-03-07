@Artoo.module 'LegalHostingAbuseApp.Unprocess', (Unprocess, App, Backbone, Marionette, $, _) ->
  
  class Unprocess.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { report } = options
      
      unprocessView = @getUnprocessView report
      
      form = App.request 'form:component', unprocessView,
        proxy:      'modal'
        model:      report
        saveMethod: 'markUnprocessed'
        onCancel:   => @region.empty()
        onSuccess:  => @region.empty()
      
      @show form
          
    getUnprocessView: (report) ->
      schema = new Unprocess.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  report