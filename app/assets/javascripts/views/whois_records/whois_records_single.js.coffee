class Whois.Views.WhoisRecordsSingle extends Backbone.View

  template: JST['whois_records/single']
  
  el: '#single-whois-container'
  
  events:
    'submit #single-whois': 'submitForm'
  
  initialize: (options) ->
    this.model = new Whois.Models.WhoisRecord(options || {})
    
    this.model.on 'sync', this.render, this
    this.model.on 'invalid', this.handleError, this
  
  render: ->
    this.$el.html this.template(this.model.attributes)
    this
    
  submitForm: (event) ->
    event.preventDefault()
    name = this.$('#name').val().trim()
    if name.length > 0
      this.model.set 'name', name
      this.lookup()
    
  lookup: ->
    this.$('.panel').html '<p style="text-align:center;"><i class="fa fa-spinner fa-spin fa-2x"></i></p>'
    this.model.getWhois()
  
  handleError: ->
    toastr.error this.model.get('error')
    this.render()