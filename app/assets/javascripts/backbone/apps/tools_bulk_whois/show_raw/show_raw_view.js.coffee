@Artoo.module 'ToolsBulkWhoisApp.ShowRaw', (ShowRaw, App, Backbone, Marionette, $, _) ->
  
  class ShowRaw.RawWhois extends App.Views.ItemView
    template: 'tools_bulk_whois/show_raw/raw_whois'
    
    initialize: (options) ->
      @record = options.record
      
    serializeData: ->
      whoisRecord: @record['whois_record']
      
    modal: ->
      title: @record['domain_name']