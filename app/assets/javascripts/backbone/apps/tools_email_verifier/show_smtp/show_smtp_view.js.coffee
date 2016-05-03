@Artoo.module 'ToolsEmailVerifierApp.ShowSmtp', (ShowSmtp, App, Backbone, Marionette, $, _) ->
  
  class ShowSmtp.SmtpSession extends App.Views.ItemView
    template: 'tools_email_verifier/show_smtp/session'
    
    modal: ->
      title: @model.get('email')
      
    serializeData: ->
      logs = _.chain @model.get('session')
              .values()
              .flatten()
              .groupBy (el, index) -> Math.floor index / 2
              .toArray()
              .value()
      logs: logs