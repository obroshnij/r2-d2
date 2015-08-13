class Whois.Views.WhoisRecordsBulk extends Backbone.View

  template: JST['whois_records/bulk']
  
  el: '#bulk-whois-container'
  
  events:
    'submit #bulk-whois': 'submitForm'
    'click .prop-box': 'showProperties'
    'click .retry-failed': 'retryFailed'
    
  initialize: ->
    this.collection = new Whois.Collections.WhoisRecords()
    this.failed_collection = new Whois.Collections.WhoisRecords()
    this.properties = ['status', 'nameservers']
    
    this.listenTo this.collection, 'sync', this.render
    this.listenTo this.failed_collection, 'sync', this.updateFailed
  
  render: ->
    window.props = this.properties
    this.$el.html this.template(collection: this.collection, properties: this.properties)
    this
    
  submitForm: (event) ->
    event.preventDefault()
    names = this.$('#names').val().trim()
    if names.length > 0
      this.lookup(names)
      
  lookup: (names) ->
    this.collection.getWhois(names)
    this.$('#whois-table').remove()
    spinner('.loader-bulk')
    this.$('form input[type="submit"]').prop('disabled', true)
    
  showProperties: ->
    this.properties = this.$('input[type="checkbox"]:checked').map( (index, item) -> $(item).attr('name') )
    this.render()
  
  retryFailed: ->
    failed = this.collection.remove(this.collection.failed()).map( (whois) -> whois.get('name') ).join(' ')
    this.failed_collection.getWhois(failed)
    this.$('#whois-table').remove()
    spinner('.loader-bulk')
    this.$('form input[type="submit"]').prop('disabled', true)
    this.$('.retry-failed').addClass('disabled')
    
  updateFailed: ->
    this.collection.add this.failed_collection.models
    this.failed_collection.reset()
    this.render()