@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.EmailMasker extends App.Entities.Model
    urlRoot: -> Routes.tools_email_maskers_path()


  API =

    newEmailMasker: (attrs) ->
      new Entities.EmailMasker attrs

  App.reqres.setHandler 'email:masker:entity', (attrs = {}) ->
    API.newEmailMasker attrs
