@Artoo.module 'LegalNcUsersApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->

      ncUser = App.request('new:legal:nc:user')
      
      newView = @getNewView ncUser
      
      form = App.request 'form:component', newView,
        proxy:     'modal'
        model:     ncUser
        onCancel:  => @region.empty()
        onSuccess: => @region.empty()
      
      @show form
      
    getNewView: (ncUser) ->
      schema = new New.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  ncUser