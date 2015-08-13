class Whois.Collections.WhoisRecords extends Backbone.Collection

  model: Whois.Models.WhoisRecord
  
  url: 'api/whois_records'
  
  initialize: ->
    this.names = []
  
  getWhois: (names) ->
    this.fetch
      data: $.param
        names: names
      reset: true
      type: 'POST'
      success: (self, xhr, options) ->
        self.names = _.map( self.toJSON(), (whois) -> whois.name )
        attrs = _.map( self.toJSON(), (whois) -> _.keys(whois.properties) if whois.properties )
        self.uniq_attrs = _.compact(_.uniq(_.flatten(attrs)))
  
  successful: ->
    this.filter (whois) -> whois.get('record')
    
  failed: ->
    this.filter (whois) -> !whois.get('record')