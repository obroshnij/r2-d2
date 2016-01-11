@Artoo.module 'Utilities', (Utilities, App, Backbone, Marionette, $, _) ->
  
  App.commands.setHandler 'when:synced', (entities, callback) ->
    
    xhrs = _.chain([entities]).flatten().pluck('_sync').value()
    
    $.when(xhrs...).always ->
      callback()