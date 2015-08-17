class Whois.Collections.WhoisRecords extends Backbone.Collection

  model: Whois.Models.WhoisRecord
  
  url: 'api/whois_records'
    
  parseNames: (names) ->
    this.fetch
      data: $.param
        names: names
      reset: true
      type: 'POST'
      success: (self, xhr, options) ->
        self.trigger 'whois:parsed'
  
  getWhois: ->
    this.fetch
      data: $.param
        names: this.names().join(' ')
      reset: true
      success: (self, xhr, options) ->
        self.trigger 'whois:batch:completed'

  names: ->
    _.map( this.toJSON(), (whois) -> whois.name )

  uniq_attrs: ->
    attrs = _.map( this.toJSON(), (whois) -> _.keys(whois.properties) if whois.properties )
    _.compact(_.uniq(_.flatten(attrs)))

  successful: ->
    this.filter (whois) -> whois.get('record')

  failed: ->
    this.filter (whois) -> !whois.get('record')