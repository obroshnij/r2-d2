class Whois.Routers.WhoisRecords extends Backbone.Router

  routes:
    '': 'single'
    ':name': 'singleWithName'
    
  single: ->
    new Whois.Views.WhoisRecordsSingle()
    
  singleWithName: (name) ->
    new Whois.Views.WhoisRecordsSingle(name: name).lookup()