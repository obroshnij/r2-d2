@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Compensation.Stats extends App.Entities.Model
    url: -> Routes.domains_compensation_stats_path()

    defaults:
      date_range: "#{moment().startOf('month').format('DD MMMM YYYY')} - #{moment().endOf('month').format('DD MMMM YYYY')}"

    show: (params = {}, options = {}) ->
      _.defaults options,
        callback: ->

      @set params
      
      @fetch data: $.param(@attributes), success: options.callback


  API =

    getCompensationStats: ->
      stats = new Entities.Compensation.Stats
      stats.show()
      stats


  App.reqres.setHandler 'domains:compensation:stats:entity', ->
    API.getCompensationStats()
