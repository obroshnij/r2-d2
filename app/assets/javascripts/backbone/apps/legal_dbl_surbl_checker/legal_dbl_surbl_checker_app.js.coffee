@Artoo.module 'LegalDblSurblCheckerApp', (LegalDblSurblCheckerApp, App, Backbone, Marionette, $, _) ->

  class LegalDblSurblCheckerApp.Router extends App.Routers.Base

    appRoutes:
      'legal/dbl_surbl' : 'newDblSurblCheck'

  API =

    newDblSurblCheck: (region) ->
      new LegalDblSurblCheckerApp.New.Controller
        region: region

  LegalDblSurblCheckerApp.on 'start', ->
    new LegalDblSurblCheckerApp.Router
      controller: API