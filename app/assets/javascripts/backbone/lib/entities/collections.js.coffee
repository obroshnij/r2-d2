@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Collection extends Backbone.PageableCollection

    _entityType: 'collection'

    parseRecords: (resp) ->
      resp.items

    parseState: (resp, queryParams, state, options) ->
      resp.pagination

    search: (data) ->
      @ransack = data if data
      @getPage 1

    export: (data = {}) ->
      window.location = this.url() + "/export?" + $.param(q: data)
