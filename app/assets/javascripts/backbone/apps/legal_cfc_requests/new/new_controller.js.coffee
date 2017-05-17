@Artoo.module 'LegalCfcRequestsApp.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Application

    initialize: (options) ->
      @request = if options.id then App.request('cfc:request:entity', options.id) else App.request('new:cfc:request:entity')

      @layout = @getLayoutView()

      @listenTo @layout, 'show', =>
        @formRegion()

      @show @layout

      findRelatedRequests = _.debounce(@findRelatedRequests.bind(this), 500)

      App.execute 'when:synced', @request, =>
        $('#nc_username').on          'keyup',  findRelatedRequests
        $('[name="request_type"]').on 'change', findRelatedRequests
        $('#recheck_reason').on       'keyup',  findRelatedRequests

    formRegion: ->
      newView = @getNewView @request

      form = App.request 'form:component', newView,
        model:     @request
        onSuccess: -> App.vent.trigger 'cfc:request:created'
        onCancel:  -> App.vent.trigger 'new:cfc:request:cancelled'

      @show form, region: @layout.formRegion, loading: true

    getNewView: ->
      schema = new New.FormSchema
      App.request 'form:fields:component',
        schema: schema
        model:  @request

    getLayoutView: ->
      new New.Layout

    findRelatedRequests: ->
      console.log 123123
      $.ajax
        method: 'GET',
        url:    '/legal/cfc_requests/check_errors'
        data:
          nc_username:    $('#nc_username').val()
          request_type:   $('[name="request_type"]:checked').val()
          recheck_reason: $('#recheck_reason').val()

      .then (data) =>
        reasonRequired = data.recheck_reason_required.toString()
        $('#requiresRecheckReason').val(reasonRequired).trigger('change')
        @request.setDuplicateError data.errors
