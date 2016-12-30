@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.LinkDisabler extends App.Entities.Model

    urlRoot: -> Routes.legal_link_disablers_path()

    resourceName: 'LaTool'

  API =

    newLinkDisabler: (attrs) ->
      new Entities.LinkDisabler attrs

  App.reqres.setHandler 'link:disabler:entity', (attrs = {}) ->
    API.newLinkDisabler attrs