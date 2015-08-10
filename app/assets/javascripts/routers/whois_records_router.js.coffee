class Whois.Routers.WhoisRecords extends Backbone.Router

  routes:
    '': 'index'
    
  index: ->
    new Whois.Views.WhoisRecordsIndex()