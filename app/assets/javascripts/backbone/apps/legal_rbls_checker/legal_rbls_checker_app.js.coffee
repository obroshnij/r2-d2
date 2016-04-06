@Artoo.module 'LegalRblsCheckerApp', (LegalRblsCheckerApp, App, Backbone, Marionette, $, _) ->
  
  API =

    newCheck: (region) ->
      new LegalRblsCheckerApp.New.Controller
        region: region
  
  App.vent.on 'legal:rbls:nav:selected', (nav, region) ->
    return if nav isnt 'Checker'
    
    API.newCheck region