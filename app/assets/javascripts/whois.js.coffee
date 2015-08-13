window.Whois =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    this.router = new Whois.Routers.WhoisRecords()
    Backbone.history.start()
