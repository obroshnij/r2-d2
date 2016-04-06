@Artoo.module 'LegalRblsListApp.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  
  class Edit.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      { rbl } = options
      
      editView = @getEditView rbl
      
      form = App.request 'form:component', editView,
        proxy:     'modal'
        model:     rbl
        onCancel:  => @region.empty()
        onSuccess: => @region.empty()
      
      @show form
      
    getEditView: (rbl) ->
      schema = new Edit.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  rbl