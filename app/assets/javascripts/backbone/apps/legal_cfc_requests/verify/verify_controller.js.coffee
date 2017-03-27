@Artoo.module 'LegalCfcRequestsApp.Verify', (Verify, App, Backbone, Marionette, $, _) ->

  class Verify.Controller extends App.Controllers.Application

    initialize: (options) ->
      { request } = options

      verifyView = @getVerifyView request

      form = App.request 'form:component', verifyView,
        proxy:      'modal'
        model:      request
        saveMethod: 'verify'
        onCancel:  => @region.empty()
        onSuccess: => @region.empty()

      @show form

    getVerifyView: (request) ->
      schema = new Verify.Schema

      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  request
