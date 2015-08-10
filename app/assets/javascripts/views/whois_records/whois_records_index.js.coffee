class Whois.Views.WhoisRecordsIndex extends Backbone.View
  
  template: JST['whois_records/index']
  
  el: '#whois-container'
  
  events:
    'click dd.single': 'singleMode'
    'click dd.bulk': 'bulkMode'
  
  initialize: ->
    this.render()
    this.singleView = new Whois.Views.WhoisRecordsSingle().render()
    this.bulkView = new Whois.Views.WhoisRecordsBulk().render()
    this.$('dd.single').click()
    
  render: ->
    this.$el.html this.template()
    this
    
  singleMode: ->
    this.$('dd.single').addClass('active')
    this.$('dd.bulk').removeClass('active')
    
    this.singleView.$el.show()
    this.bulkView.$el.hide()
    
  bulkMode: ->
    this.$('dd.single').removeClass('active')
    this.$('dd.bulk').addClass('active')
  
    this.singleView.$el.hide()
    this.bulkView.$el.show()