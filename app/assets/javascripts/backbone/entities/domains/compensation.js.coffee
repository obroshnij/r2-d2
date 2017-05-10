@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation extends App.Entities.Model
    urlRoot: -> Routes.domains_compensations_path()

    resourceName: 'Domains::Compensation'

    statusColorLookups: { '_new': 'primary', '_checked': 'success' }

    mutators:

      reference: ->
        "#{s.capitalize(@get('reference_item'))} #{@get('reference_id')}"

      productAndService: ->
        return @get('product_compensated') unless @get('service_compensated')
        "#{@get('product_compensated')} : #{@get('service_compensated')}"

      compensation: ->
        if @get('compensation_type_id') is 7
          return "#{@get('compensation_type')} : #{@get('tier_pricing')}"

        if @get('compensation_type_id') is 1 and @get('discount_recurring')
          return "#{@get('compensation_type')} (recurring) : #{@get('compensation_amount')} USD"

        "#{@get('compensation_type')} : #{@get('compensation_amount')} USD"

      satisfied: ->
        return "Don't know / not sure" if @get('client_satisfied') is 'n/a'
        return "Yes"                   if @get('client_satisfied')
        "No"

      statusName: ->
        s(@get('status')).replaceAll('_', '').capitalize().value()

      statusColor: ->
        @statusColorLookups[@get('status')] if @get('status')

      editLog: ->
        return [] unless @get('logs')
        @get('logs').map (log) -> [
          "#{s.capitalize(log.action)} by #{log.user} at #{log.created_at}",
          _.map(log.payload, (val, key) -> "#{key}: #{val.join(' => ')}").join("\n")
        ].join("\n\n")

    qaCheck: (attributes = {}, options = {}) ->
      options.url = Routes.qa_check_domains_compensation_path(@id)
      @save attributes, options


  class Entities.CompensationsCollection extends App.Entities.Collection
    model: Entities.Compensation

    url: -> Routes.domains_compensations_path()


  API =

    getNewCompensation: ->
      new Entities.Compensation

    getCompensationsCollection: ->
      compensations = new Entities.CompensationsCollection
      compensations.fetch()
      compensations

    getCompensation: (id) ->
      compensation = new Entities.Compensation id: id
      compensation.fetch()
      compensation


  App.reqres.setHandler 'new:compensation:entity', ->
    API.getNewCompensation()

  App.reqres.setHandler 'compensation:entities', ->
    API.getCompensationsCollection()

  App.reqres.setHandler 'compensation:entity', (id) ->
    API.getCompensation id
