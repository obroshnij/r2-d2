@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.DblSurblCheck extends App.Entities.Model

    mutators:

      dblText: ->
        if @get('dbl') then 'Listed' else 'Not Listed'

      surblText: ->
        if @get('surbl') then 'Listed' else 'Not Listed'

      hostColor: ->
        return 'red'    if @get('dbl') and @get('surbl')
        return 'yellow' if @get('dbl') or  @get('surbl')
        'green'

      dblColor: ->
        if @get('dbl') then 'red' else 'green'

      surblColor: ->
        if @get('surbl') then 'red' else 'green'


  class Entities.DblSurblChecksCollection extends App.Entities.Collection
    model: Entities.DblSurblCheck


  class Entities.DblSurblChecker extends App.Entities.Model
    urlRoot: -> Routes.legal_dbl_surbl_checks_path()

    resourceName: 'LaTool'

    initialize: ->
      @records = new Entities.DblSurblChecksCollection
      @listenTo @, 'created', -> @records.reset @get('records')


  API =

    getDblSurblChecker: ->
      new Entities.DblSurblChecker


  App.reqres.setHandler 'new:dbl:surbl:ckecker:entity', ->
    API.getDblSurblChecker()
