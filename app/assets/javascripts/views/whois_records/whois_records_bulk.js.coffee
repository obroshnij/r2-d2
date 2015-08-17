class Whois.Views.WhoisRecordsBulk extends Backbone.View

  template: JST['whois_records/bulk']
  
  el: '#bulk-whois-container'
  
  events:
    'submit #bulk-whois': 'submitForm'
    'click .prop-box': 'showProperties'
    'click .retry-failed': 'retryFailed'
    
  initialize: ->
    this.pending = new Whois.Collections.WhoisRecords()
    this.temp = new Whois.Collections.WhoisRecords()
    this.completed = new Whois.Collections.WhoisRecords()
    
    this.bulk_info_view = new Whois.Views.WhoisRecordsBulkInfo()
    
    this.properties = ['status', 'nameservers']
    
    this.listenTo this.pending, 'whois:parsed', this.splitAndWhois
    this.listenTo this.temp, 'whois:batch:completed', this.splitAndWhois
    
  splitAndWhois: ->
    this.saveTemp()
    batch = this.pending.first(10)
    this.temp.reset()
    if batch.length > 0
      this.bulk_info_view.render(this.pending, this.completed)
      this.pending.remove batch
      this.temp.add batch
      this.temp.getWhois()
    else
      this.render()
  
  saveTemp: ->
    if this.temp.length > 0
      this.completed.add this.temp.models
  
  render: ->
    this.$el.html this.template(pending: this.pending, completed: this.completed, properties: this.properties)
    this.bulk_info_view.setElement('#bulk-whois-info')
    this.bulk_info_view.render(this.pending, this.completed)
    this
    
  submitForm: (event) ->
    event.preventDefault()
    names = this.$('#names').val().trim()
    if names.length > 0
      this.pending.reset()
      this.completed.reset()
      this.lookup(names)

  lookup: (names) ->
    this.pending.parseNames(names)
    
    this.$('#whois-table').remove()
    spinner('.loader-bulk')
    this.$('form input[type="submit"]').prop('disabled', true)

  showProperties: ->
    this.properties = this.$('input[type="checkbox"]:checked').map( (index, item) -> $(item).attr('name') )
    this.render()

  retryFailed: ->
    failed = this.completed.remove(this.completed.failed()).map( (whois) -> whois.get('name') )
    this.lookup failed.join(' ')
