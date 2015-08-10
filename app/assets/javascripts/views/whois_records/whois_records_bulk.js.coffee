class Whois.Views.WhoisRecordsBulk extends Backbone.View

  template: JST['whois_records/bulk']
  
  el: '#bulk-whois-container'
  
  events:
    'submit #bulk-whois': 'submitForm'
    'click .prop-box': 'showProperties'
    
  initialize: ->
    this.collection = new Whois.Collections.WhoisRecords()
    this.properties = ['status', 'nameservers']
    
    this.collection.on 'sync', this.render, this
  
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
    this.$('.loader').html("<i class='fa fa-spinner fa-spin fa-2x'></i>")
    
  showProperties: ->
    this.properties = this.$('input[type="checkbox"]:checked').map( (index, item) -> $(item).attr('name') )
    this.render()
    