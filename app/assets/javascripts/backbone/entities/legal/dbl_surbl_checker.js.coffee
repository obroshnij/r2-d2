@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.DblSurblCheck extends App.Entities.Model
    mutators:
      dblText: ->
        if @get('dbl') == false
          'No'
        else
          'Yes'

      surblText: ->
        if @get('surbl') == false
          'No'
        else
          'Yes'

  class Entities.DblSurblChecksCollection extends App.Entities.Collection
    model: Entities.DblSurblCheck


  class Entities.DblSurblChecker extends App.Entities.Model
    urlRoot: -> Routes.legal_dbl_surbl_checks_path()

    resourceName: 'Legal::DblSurblCheck'

    initialize: ->
      @records = new Entities.DblSurblChecksCollection
      @listenTo @, 'change:records', -> @records.reset @get('records')

  API =

    getDblSurblChecker: ->
      new Entities.DblSurblChecker

  App.reqres.setHandler 'new:dbl:surbl:ckecker:entity', ->
    API.getDblSurblChecker()
