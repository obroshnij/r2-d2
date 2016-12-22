@Artoo.module 'LegalRblsListApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      rbl = App.request 'new:legal:rbl:entity'
      { rbls } = options

      newView = @getNewView rbl

      form = App.request 'form:component', newView,
        proxy:     'modal'
        model:     rbl
        onCancel:  => @region.empty()
        onSuccess: => @region.empty() and rlbs.search()

      @show form

    getNewView: (rbl) ->
      schema = new New.Schema

      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  rbl
