@Artoo.module 'ToolsEmailVerifierApp.ShowSmtp', (ShowSmtp, App, Backbone, Marionette, $, _) ->
  
  class ShowSmtp.Controller extends App.Controllers.Application
  
    initialize: (options) ->
      { record } = options
      
      sessionView = @getSessionView record
      
      @show sessionView
      
    getSessionView: (record) ->
      new ShowSmtp.SmtpSession
        model: record