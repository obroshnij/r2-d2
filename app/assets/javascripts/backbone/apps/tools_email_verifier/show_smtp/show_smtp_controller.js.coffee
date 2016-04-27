@Artoo.module 'ToolsEmailVerifierApp.ShowSmtp', (ShowSmtp, App, Backbone, Marionette, $, _) ->
  
  class ShowSmtp.Controller extends App.Controllers.Application
  
    initialize: (options) ->
      { email, session } = options
      console.log session