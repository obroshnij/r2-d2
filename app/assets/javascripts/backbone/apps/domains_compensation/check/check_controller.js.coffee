@Artoo.module 'DomainsCompensationApp.Check', (Check, App, Backbone, Marionette, $, _) ->

  class Check.Controller extends App.Controllers.Application

    initialize: (options) ->
      { compensation } = options

      checkView = @getCheckView compensation

      form = App.request 'form:component', checkView,
        proxy:      'modal'
        model:      compensation
        saveMethod: 'qaCheck'
        onCancel:  => @region.empty()
        onSuccess: => @region.empty()

      @show form

    getCheckView: (compensation) ->
      schema = new Check.Schema

      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  compensation
