class Whois.Models.WhoisRecord extends Backbone.Model
  
  urlRoot: 'api/whois_records'
  
  initialize: ->
    this.setId() unless _.isUndefined this.get('name')
    this.on 'change:name', this.setId
    
  setId: ->
    this.set 'id', this.get('name').split('.').join('_')
    
  getWhois: ->
    this.fetch
      error: (self, xhr, options) ->
        self.set('error', xhr.responseJSON.error)
        self.unset('record')
        self.trigger('invalid')
      success: (self, xhr, options) ->
        self.unset('error')