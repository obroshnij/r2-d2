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

      checkForFraudResult: ->
        return 'Fraud'    if @get('frauded')
        return 'Verified' if @get('verification_ticket_id')
        'Okay'

      findRelationsResult: ->
        return 'found'        if @get('relations_status') is 'has_relations'
        return 'not searched' if @get('relations_status') is 'unknown_relations'
        return 'not found'    if @get('relations_status') is 'has_no_relations'

      statusColor: ->
        switch @get('status')
          when '_new'       then 'primary'
          when '_processed' then 'success'
          when '_pending'   then 'warning'

      serviceType: ->
        s.humanize @get('service_type')

      abuseType: ->
        return 'Fraud/Scam' if @get('abuse_type') is 'scam'
        s.humanize @get('abuse_type')

      serviceStatus: ->
        s.humanize @get('service_status')

      editCommentRequired: ->
        not @isNew()

      verifyCommentRequired: ->
        @get('status') is '_pending'

      processCommentRequired: ->
        @get('status') is '_processed'

      requiresRecheckReason: ->
        !!@get('recheck_reason')

      editLog: ->
        return unless @get('logs')?.length

        _.map @get('logs'), (log) ->
          line = "#{s.capitalize(log.action)} by #{log.user} at #{log.created_at}"
          line = "#{line}\nComment: #{log.comment}" if log.comment
          line
        .join("\n\n")

      canBeEdited: ->
        @get('status') is '_new'

      canBeVerified: ->
        _.includes(['_new', '_pending'], @get('status')) and @get('request_type') is 'check_for_fraud'

      canBeProcessed: ->
        true

    verify: (attributes = {}, options = {}) ->
      options.url = Routes.verify_legal_cfc_request_path(@id)
      @save attributes, options

    process: (attributes = {}, options = {}) ->
      options.url = Routes.mark_processed_legal_cfc_request_path(@id)
      @save attributes, options

    setDuplicateError: (error) ->
      { nc_username, recheck_reason } = error
      errors = @get('_errors') or {}

      if nc_username    then errors.nc_username    = nc_username    else delete errors.nc_username
      if recheck_reason then errors.recheck_reason = recheck_reason else delete errors.recheck_reason

      @set('_errors', errors)
      @trigger('change:_errors', this, errors)


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
