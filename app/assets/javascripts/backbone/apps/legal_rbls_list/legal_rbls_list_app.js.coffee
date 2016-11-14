@Artoo.module 'LegalRblsListApp', (LegalRblsListApp, App, Backbone, Marionette, $, _) ->

  API =

    list: (region) ->
      new LegalRblsListApp.List.Controller
        region: region

    edit: (rbl) ->
      new LegalRblsListApp.Edit.Controller
        region: App.modalRegion
        rbl:    rbl

    newRbl: (rbls) ->
      new LegalRblsListApp.New.Controller
        region: App.modalRegion
        rbls:   rbls


  App.vent.on 'legal:rbls:nav:selected', (nav, region) ->
    return if nav isnt 'List'

    API.list region

  App.vent.on 'edit:legal:rbl:clicked', (rbl) ->
    API.edit rbl

  App.vent.on 'new:legal:rbl:clicked', (rbls) ->
    API.newRbl rbls
