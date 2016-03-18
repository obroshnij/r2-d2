@Artoo.module 'ToolsBulkWhoisApp.ShowRaw', (ShowRaw, App, Backbone, Marionette, $, _) ->
  
  class ShowRaw.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      record = options.record
      
      rawWhoisView = @getRawWhoisView record
      
      @show rawWhoisView
      
    getRawWhoisView: (record) ->
      new ShowRaw.RawWhois
        record: record