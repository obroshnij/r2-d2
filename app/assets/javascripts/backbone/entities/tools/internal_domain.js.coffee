@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.InternalDomain extends App.Entities.Model
    urlRoot: -> Routes.tools_internal_domains_path()

    resourceName: 'Tools::InternalDomain'


  class Entities.InternalDomainsCollection extends App.Entities.Collection
    model: Entities.InternalDomain

    url: -> Routes.tools_internal_domains_path()


  API =

    getInternalDomainsCollection: ->
      domains = new Entities.InternalDomainsCollection
      domains.fetch()
      domains


  App.reqres.setHandler 'internal:domain:entities', ->
    API.getInternalDomainsCollection()
