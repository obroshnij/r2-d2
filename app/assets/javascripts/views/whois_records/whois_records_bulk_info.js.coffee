class Whois.Views.WhoisRecordsBulkInfo extends Backbone.View

  template: JST['whois_records/bulk_info']
  
  render: (pending, completed) ->
    this.$el.html this.template(pending: pending, completed: completed)
    this