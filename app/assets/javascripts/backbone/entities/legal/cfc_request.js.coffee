@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.CfcRequest extends App.Entities.Model
    urlRoot: -> Routes.legal_cfc_requests_path()

    resourceName: 'Legal::CfcRequest'

    mutators:

      requestType: ->
        s.humanize @get('request_type')

      findRelationsReason: ->
        s.humanize @get('find_relations_reason')

      statusName: ->
        switch @get('status')
          when '_new'       then 'New'
          when '_processed' then 'Processed'
          when '_pending'   then 'Pending Verification'

      actionName: ->
        switch @get('status')
          when '_processed' then 'Processed'
          when '_pending'   then 'Initiated'

      processedResult: ->
        res = []

        if @get('frauded') then res.push('Frauded') else res.push('Not frauded')

        relCount = @get('relations')?.length
        res.push("1 related user")            if relCount is 1
        res.push("#{relCount} related users") if relCount > 1

        res.join ', '

      statusColor: ->
        switch @get('status')
          when '_new'       then 'primary'
          when '_processed' then 'success'
          when '_pending'   then 'warning'

      serviceType: ->
        s.humanize @get('service_type')

      abuseType: ->
        s.humanize @get('abuse_type')

      serviceStatus: ->
        s.humanize @get('service_status')

    verify: (attributes = {}, options = {}) ->
      options.url = Routes.verify_legal_cfc_request_path(@id)
      @save attributes, options

    process: (attributes = {}, options = {}) ->
      options.url = Routes.mark_processed_legal_cfc_request_path(@id)
      @save attributes, options


  class Entities.CfcRequestsCollection extends App.Entities.Collection
    model: Entities.CfcRequest

    url: -> Routes.legal_cfc_requests_path()


  API =

    newRequest: (attrs = {}) ->
      new Entities.CfcRequest attrs

    getRequestsCollection: ->
      requests = new Entities.CfcRequestsCollection
      requests.fetch()
      requests

    getRequest: (id) ->
      request = new Entities.CfcRequest id: id
      request.fetch()
      request


  App.reqres.setHandler 'new:cfc:request:entity', (attrs = {}) ->
    API.newRequest attrs

  App.reqres.setHandler 'cfc:requests:entities', ->
    API.getRequestsCollection()

  App.reqres.setHandler 'cfc:request:entity', (id) ->
    API.getRequest id
