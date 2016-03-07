@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  App.commands.setHandler 'notify:info', (message) ->
    toastr.info message
    
  App.commands.setHandler 'notify:error', (message) ->
    toastr.error message